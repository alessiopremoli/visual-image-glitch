# Visual Image Glitch

A multistep audio video generative process:
- Python reads raw data and outputs a simplified csv
- Processing read the csv datas and glitches accordignly a set of picutre (the pixel sort algorythm is a slight variation of the [ASDFPixelSort](https://github.com/kimasendorf/ASDFPixelSort) and saves a pictures in a specific format
- Supercollider generates a filtered white noise accordingly to the csv data
- A JS script runs and using `ffmpeg`merges the pictures saved by Processing in a series of videos


