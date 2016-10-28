# Band-Practice

## What?

Band Practice is a tool to format, organize, and deploy song lyrics with chords. `PDF` is currently the only 
(still in progress) deployment format, with `HTML` being the next goal.

## Building

Build with Xcode 8

## Usage

`bandpractice /path/to/book.json /path/to/deploy/to`

## Song Source Structure

### Directory

```
book.json
  songs/
        song.txt
        song2.txt
  covers/
        song3.txt
        song4.txt
  etc/
        song5.txt
        song6.txt
```

### JSON manifest

```json
{
  "name": "Name Of Music Book",
  "songs": [
    {
      "title": "Tile Here",
      "artist": "Artist Here",
      "source": "songs/song.txt"
    },
    {
      "title": "Title Here",
      "artist": "Artist Here",
      "source": "covers/song3.txt"
    }
  ]
}
```
