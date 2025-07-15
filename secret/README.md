# qsvunpack

This directory is **not** part of the Qt GUI application.  The two C files here are small, self-contained demo programs intended to explain the inner workings of the **.qsv** container format.  They do **not** perform full transcoding.

If you spot an error, have additional information, or find that the format changes in newer client versions, please open an issue or send a pull request – contributions are welcome!

---

## Files

| File | Purpose |
|------|---------|
| `qsvformat.c` | Tiny demo that prints a human-readable description of a **.qsv** file’s structure. |
| `qsvunpack.c` | Extracts each video segment from a **.qsv** file and concatenates them.  The production-grade algorithm used in the Qt application is more robust, but this demo makes the idea clear. |

---

## Format Reverse-Engineering Notes

### File Header

| Offset (absolute) | Size (bytes) | Field | Description |
|-------------------|-------------|-------|-------------|
| `0x00` | `0x0A` | `signature` | ASCII magic string **"QIYI VIDEO"** |
| `0x0A` | `0x04` | `version` | 0x01 or 0x02 |
| `0x0E` | `0x10` | `vid` | Video ID |
| `0x1E` | `0x04` | `_unknown1` | Must be `0x01` (purpose unknown) |
| `0x22` | `0x20` | `_unknown2` | Always zero (purpose unknown) |
| `0x42` | `0x04` | `_unknown3` | Unknown, under investigation |
| `0x46` | `0x04` | `_unknown4` | Unknown, under investigation |
| `0x4A` | `0x08` | `xml_offset` | Absolute offset of the encrypted [XML section](#xml-section) |
| `0x52` | `0x04` | `xml_size` | Size of the encrypted [XML section](#xml-section) |
| `0x56` | `0x04` | `nb_indices` | Number of [index entries](#index-area) |

### Index Area

| Offset (absolute) | Size (bytes) | Field | Description |
|-------------------|-------------|-------|-------------|
| `0x5A` | `ceil(nb_index / 8)` | `_unknown_flag` | Bit-flags – one bit per segment, purpose TBD |
| (following) | `nb_index * 0x1C` | `indices` | Array of encrypted index records |

Each index record is 0x1C bytes long and, once decrypted, describes one [video segment](#video-segments):

| Offset (within record) | Size (bytes) | Field | Description |
|------------------------|-------------|-------|-------------|
| `0x00` | `0x10` | `_codetable` | Decryption key for the two fields below |
| `0x10` | `0x08` | `segment_offset` | Absolute file offset of the segment |
| `0x18` | `0x04` | `segment_size` | Size of the segment |

### XML Section

An encrypted XML blob plus some binary padding.  Details are still being analysed.

### Video Segments

A **.qsv** file contains multiple encrypted video segments.  Each segment is located via the [index area](#index-area); the first `0x400` bytes of every segment are encrypted.

Two container formats have been observed so far:
* **FLV** – used by older versions of the client
* **MPEG-TS** – used by newer versions

Each segment contains its own header and metadata.  Presentation timestamps of a segment start **after** the previous one (i.e. not reset to zero).
