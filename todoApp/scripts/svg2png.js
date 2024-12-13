const sharp = require('sharp')
const fs = require('fs')
const path = require('path')

const SVG_DIR = path.join(__dirname, '../static/images/tabbar/svg')
const PNG_DIR = path.join(__dirname, '../static/tabbar')

// 确保输出目录存在
if (!fs.existsSync(PNG_DIR)) {
  fs.mkdirSync(PNG_DIR, { recursive: true })
}

// 转换配置
const config = {
  width: 48,  // 输出图片宽度
  height: 48  // 输出图片高度
}

// 获取所有SVG文件
const svgFiles = fs.readdirSync(SVG_DIR).filter(file => file.endsWith('.svg'))

// 转换函数
async function convertSvgToPng(svgFile) {
  const inputPath = path.join(SVG_DIR, svgFile)
  const outputPath = path.join(PNG_DIR, svgFile.replace('.svg', '.png'))
  
  try {
    await sharp(inputPath)
      .resize(config.width, config.height)
      .png()
      .toFile(outputPath)
    
    console.log(`Converted ${svgFile} to PNG`)
  } catch (error) {
    console.error(`Error converting ${svgFile}:`, error)
  }
}

// 执行转换
async function convertAll() {
  console.log('Starting conversion...')
  
  for (const svgFile of svgFiles) {
    await convertSvgToPng(svgFile)
  }
  
  console.log('Conversion completed!')
}

convertAll() 