const fs = require('fs');
const { execSync } = require('child_process');

const progressBar = (value, total) => {
    let progress = '#'.repeat(value + 1) + '-'.repeat(total - 1 - value);
    process.stdout.clearLine();
    process.stdout.cursorTo(0);
    process.stdout.write(`\r[${progress}]`);
}

// 1 - get all files
process.stdout.write('\033c');
console.log('#### MERGING A LOT OF IMAGES INTO A SET OF MP4 ####');
console.log('Getting all files...');

const files = [];
fs.readdirSync('./').forEach(file => {
    if (file.endsWith('.png')) {
        let fileSplitted = file.split('-');
        files.push({
            fileName: file.replace('.png', ''),
            batch: fileSplitted[1],
            duration: +fileSplitted[2],
            item: fileSplitted[3].split('.')[0],
            type: fileSplitted[3].split('.')[1],
        })
    }
});

const batches = [...new Set(files.map(f => f.batch))];
console.log(`Found ${batches.length} batches`)

batches.forEach(batch => {
    console.log(`\nRunning batch n° ${batch}`);
    let filesToElab = files.filter(f => f.batch === batch).sort((a, b) => a.duration - b.duration)
    // 2 - for each file generate an mp4 video using ffmpeg
    console.log(`Batch ${batch}: 1 - For each file generate an mp4 video using ffmpeg`);

    filesToElab.forEach((imgFile, i) => {
        progressBar(i, filesToElab.length);
        execSync(`ffmpeg -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -loop 1 -i ${imgFile.fileName}.png -pix_fmt yuv420p -t ${imgFile.duration / 1000} ${imgFile.fileName}.mp4`, { stdio: 'ignore' })
    });
    console.log('\n');

    // 3 - merge all videos together
    console.log(`Batch ${batch}: 2 - Merge all videos together`);
    let videoList = '';
    let videoDecode = '';
    filesToElab.forEach((vidFile, i) => {
        videoList = videoList + `-i ${vidFile.fileName}.mp4 `;
        videoDecode = videoDecode + `[${i}:v:0][${i}:a:0]`
    });

    let command = `ffmpeg ${videoList} -filter_complex "${videoDecode}concat=n=${filesToElab.length}:v=1:a=1[outv][outa]" -map "[outv]" -map "[outa]" video-${batch}.mp4`;
    execSync(command, { stdio: 'ignore' });


    // 4 - remove single videos
    console.log(`Batch ${batch}: 3 - Remove single videos`);
    filesToElab.forEach(imgFile => {
        fs.unlinkSync(imgFile.fileName + '.mp4')
    })
})








