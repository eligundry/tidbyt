# Tidbyt

Custom widgets for my [Tidbyt](https://tidbyt.com/).

## Widgets

- [`feelings.star](./feelings.star)` - show my latest Daylio entry's mood. [Read more](https://eligundry.com/blog/feelings-api)
- [`dril.star`](./dril.star) - show a random [@dril](https://twitter.com/dril) tweet

## Lambda

These widgets are too niche to merit submission to Tidbyt's community service. That said, I do like to keep them up to
date. As such, I created a Lambda that will regenerate them hourly. This can be found in [`server/handler.ts`](./server/handler.ts).
I have purposefully not wired up a Github Action to ship these changes automatically, so I must deploy locally.

```bash
$ cd server
$ serverless deploy
```
