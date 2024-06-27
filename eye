#!/usr/bin/env python3

from typing import Self
from PIL import Image
from io import BytesIO
from glob import glob
from dataclasses import dataclass, field

import toml
import click
import easy_scraper
import eyed3
import eyed3.id3
import requests

VERSION = "0.1.0"

Usage = """
eye - metadata for mp3 playlist

Usage: Write up metadata.toml and run `python3 eye -f ./metadata.toml`
`metadata.toml` is for `class Metadata`.
"""

Sample = """\b
metadata.toml (sample)
-----------
[default]
glob = "*.mp3"  # target files (default=*.mp3)
album = "ALBUM NAME"
artist = "ARTIST NAME"
album_artist = "MAKER NAME"
cover = "./COVER.JPEG"  # To fetch from dlsite, "dlsite:COVER.JPEG"
dlsite = "RJ***"  # can fetch some metadata from dlsite

\b
[files]
titles = [
    "01.aaa",
    "02.bbb",
]
artists = []        # To override default.artist
albums = []         # To override default.album
album_artists = []  # To override default.album_artist
covers = []         # To override default.cover
```
"""


@dataclass
class Eye:
    """Metadata for a mp3file"""

    album: str
    album_artist: str
    artist: str
    track_num: int
    total_num: int
    title: str
    cover_image_filepath: str | None


@dataclass
class Default:
    """[default]"""

    glob: str
    album: str | None
    artist: str | None
    album_artist: str | None
    cover: str | None  # "dlsite:COVER.JPG" とすると dlsite から COVER.JPG として画像を保存する
    dlsite: str | None


@dataclass
class Files:
    """[files]"""

    titles: list[str] | None
    artists: list[str] | None
    albums: list[str] | None
    album_artists: list[str] | None
    covers: list[str] | None


@dataclass
class Metadata:
    """metadata.toml"""

    default: Default
    files: Files
    _cache: dict = field(default_factory=dict)

    @property
    def eyes(self) -> list[Eye]:
        num = self.total_num
        return [
            Eye(
                artist=self.artist(i),
                album=self.album(i),
                album_artist=self.album_artist(i),
                track_num=i + 1,
                total_num=num,
                title=self.title(i),
                cover_image_filepath=self.cover(i),
            )
            for i in range(num)
        ]

    def artist(self, idx: int) -> str:
        if self.files.artists:
            return self.files.artists[idx]
        if self.default.artist:
            return self.default.artist
        if self.default.dlsite:
            return self.dlsite("artist")
        raise AssertionError("No artist")

    def album_artist(self, idx: int) -> str:
        if self.files.album_artists:
            return self.files.album_artists[idx]
        if self.default.album_artist:
            return self.default.album_artist
        if self.files.artists:
            return self.files.artists[idx]
        if self.default.artist:
            return self.default.artist
        if self.default.dlsite:
            return self.dlsite("maker")
        raise AssertionError("No album_artist")

    def album(self, idx: int) -> str:
        if self.files.albums:
            return self.files.albums[idx]
        if self.default.album:
            return self.default.album
        if self.default.dlsite:
            return self.dlsite("title")
        raise AssertionError("No album")

    def title(self, idx: int) -> str:
        if self.files.titles:
            return self.files.titles[idx]
        if self.default.dlsite:
            return self.dlsite("title")
        raise AssertionError("No title")

    def cover(self, idx: int) -> str | None:
        if self.files.covers:
            return self.files.covers[idx]
        if (
            self.default.dlsite
            and self.default.cover
            and self.default.cover.startswith("dlsite")
        ):
            # fetch og:image
            url = self.dlsite("ogimage")
            # download -> make it a square
            response = requests.get(url)
            img = Image.open(BytesIO(response.content))
            img = img.convert("RGB")
            size = max(img.size)
            background = Image.new("RGB", (size, size), (0, 0, 0))
            offset = ((size - img.width) // 2, (size - img.height) // 2)
            background.paste(img, offset)
            # save as filename
            filename = self.default.cover.removeprefix("dlsite:")
            background.save(filename)
            return filename
        if self.default.cover:
            return self.default.cover

        return None

    @property
    def filelist(self) -> list[str]:
        """files by glob"""
        return sorted(glob(str(self.default.glob)))

    @property
    def total_num(self) -> int:
        if self.files.titles:
            return len(self.files.titles)
        else:
            return len(self.filelist)

    def dlsite(self, attr: str):
        id = self.default.dlsite
        assert id
        if id not in self._cache:
            self._cache[id] = DLSite(id)
        data = self._cache[id]
        return getattr(data, attr)

    @classmethod
    def from_dict(cls, data: dict) -> Self:
        metadata = cls(
            Default(
                glob=data.get("default", {}).get("glob", "*.mp3"),
                album=data.get("default", {}).get("album"),
                artist=data.get("default", {}).get("artist"),
                album_artist=data.get("default", {}).get("album_artist"),
                cover=data.get("default", {}).get("cover"),
                dlsite=data.get("default", {}).get("dlsite"),
            ),
            Files(
                titles=data.get("files", {}).get("titles"),
                artists=data.get("files", {}).get("artists"),
                albums=data.get("files", {}).get("albums"),
                album_artists=data.get("files", {}).get("album_artists"),
                covers=data.get("files", {}).get("covers"),
            ),
        )
        return metadata


class DLSite:
    url: str
    html: str
    title: str
    artist: str | None
    maker: str
    ogimage: str | None

    def __init__(self, id: str):
        self.url = f"https://www.dlsite.com/maniax/work/=/product_id/{id}.html"
        self.html = requests.get(self.url).text
        self.title = easy_scraper.match(self.html, "<h1 id=work_name>{}</>")[0][""]
        try:
            self.artist = easy_scraper.match(
                self.html, "<tr><th>声優</th><td><a>{}</a></td></tr>"
            )[0][""]
        except Exception:
            self.artist = None
        self.maker = easy_scraper.match(
            self.html, "<tr><th>サークル名</th><td><a>{}</a></td></tr>"
        )[0][""]
        self.ogimage = self.fetch_ogimage()

    def fetch_ogimage(self) -> str | None:
        try:
            imgs = easy_scraper.match(
                self.html, '<meta property="og:image" content="{}" />'
            )
            imgurl = imgs[0][""]
            return imgurl
        except Exception:
            return None


def update(filepath: str, eye: Eye, dry_run: bool):
    # validation
    assert 1 <= eye.track_num <= eye.total_num
    if eye.cover_image_filepath:
        assert (
            eye.cover_image_filepath.endswith(".jpg")
            or eye.cover_image_filepath.endswith(".JPG")
            or eye.cover_image_filepath.endswith(".jpeg")
            or eye.cover_image_filepath.endswith(".JPEG")
        ), "Cover image should be JPEG file"

    # tagging
    if not dry_run:
        audio = eyed3.load(filepath)
        if not audio:
            raise AssertionError(f"Cannot open: {filepath}")
        audio.initTag(version=eyed3.id3.ID3_V2_4)
        if not audio.tag:
            raise AssertionError(f"Cannot tagging as ID3_V2_4: {filepath}")
        audio.tag.clear()
        audio.tag.artist = eye.artist
        audio.tag.album = eye.album
        audio.tag.album_artist = eye.album_artist
        audio.tag.track_num = (eye.track_num, eye.total_num)
        audio.tag.title = eye.title
        audio.tag.save()
        if eye.cover_image_filepath:
            cover = open(eye.cover_image_filepath, "rb").read()
            audio.tag.images.set(
                eyed3.id3.frames.ImageFrame.FRONT_COVER,
                cover,
                "image/jpeg",
            )
    print(
        f"file={filepath}, "
        f"album={eye.album}, "
        f"artist={eye.artist}, "
        f"album_artist={eye.album_artist}, "
        f"title={eye.title}, "
        f"track={eye.track_num}/{eye.total_num}, "
        f"cover={eye.cover_image_filepath}"
    )


@click.command(help=Usage, epilog=Sample)
@click.option("--dry-run", "-n", is_flag=True, default=False, show_default=True)
@click.option("--file", "-f", default="metadata.toml", show_default=True)
def main(dry_run: bool, file: str):
    data = toml.load(open(file, "rt"))
    metadata = Metadata.from_dict(data)
    files = metadata.filelist
    if not files:
        raise AssertionError(f"Not found any files for {metadata.default.glob}")
    eyes = metadata.eyes
    if dry_run:
        click.secho("[Dry-run mode]", fg="yellow")
    for f, e in zip(files, eyes):
        update(f, e, dry_run)


if __name__ == "__main__":
    click.secho(f"eye.py - v{VERSION}")
    main()
