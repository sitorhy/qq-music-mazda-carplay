import fs from 'fs';
import path from 'path';
import archiver from 'archiver';
import { globby } from 'globby'; // globby 是一个 ES 模块，需要解构导入

// --- 配置 ---
const FILE_PATTERNS = [
  // '**/*.{jpg,JPG,jpeg,JPEG,png,PNG,gif,GIF,webp,WEBP,ico,ICO,bmp,BMP}',
  '**/*.{mp3,MP3}',
  '**/*.{lrc,LRC}'
];

const IGNORE_PATTERNS = [
  'node_modules',
  '**/node_modules/**',
  'media_archive_flat.zip'
];

// 使用 import 语法时，__dirname 和 __filename 不可用。
// 我们可以使用 path.resolve('.') 来代替 process.cwd() 获取当前目录的绝对路径，
// 也可以直接使用 process.cwd()，但为了获取与文件系统相关的路径，path.resolve() 更可靠。
const BASE_DIR = path.resolve('.'); // 保证获取绝对路径
const OUTPUT_ZIP_PATH = path.join(BASE_DIR, 'media_archive_flat.zip');


/**
 * 搜索指定模式的文件并创建 ZIP 压缩包 (平铺结构)
 */
async function createZipArchive() {
  console.log(`🚀 开始搜索文件: ${FILE_PATTERNS.join(', ')}`);
  console.log(`⚠️ ZIP 文件将采用平铺结构 (不包含目录)`);

  // 1. 使用 globby 搜索文件
  const filesToArchive = await globby(FILE_PATTERNS, {
    cwd: BASE_DIR,
    ignore: IGNORE_PATTERNS,
    onlyFiles: true,
  });

  if (filesToArchive.length === 0) {
    console.log('✅ 未找到任何符合条件的文件，脚本结束。');
    return;
  }

  console.log(`✅ 找到 ${filesToArchive.length} 个文件，开始创建 ZIP 档案...`);

  // 2. 设置 archiver
  const output = fs.createWriteStream(OUTPUT_ZIP_PATH);
  const archive = archiver('zip', {
    zlib: { level: 9 }
  });

  // 监听事件
  output.on('close', () => {
    console.log(`\n🎉 归档完成!`);
    console.log(`📦 总字节数: ${archive.pointer()} bytes`);
    console.log(`💾 ZIP 文件已保存到: ${OUTPUT_ZIP_PATH}`);
  });

  archive.on('error', (err) => {
    throw err;
  });

  // 3. 管道连接
  archive.pipe(output);

  // 4. 将找到的所有文件添加到归档
  for (const filePath of filesToArchive) {
    // fullPath 保证了文件读取的正确性
    const fullPath = path.join(BASE_DIR, filePath);

    // 使用 path.basename() 来获取纯文件名
    const fileNameInZip = path.basename(filePath);

    archive.file(fullPath, { name: fileNameInZip });
  }

  // 5. 完成归档
  await archive.finalize();
}

// 执行主函数
createZipArchive().catch(err => {
  console.error('\n❌ 脚本执行发生错误:', err);
  // 在 ESM 模块中，为了安全退出，可能需要显式调用 process.exit(1)
  process.exit(1);
});