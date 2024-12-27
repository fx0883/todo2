// 开发环境配置

export let baseUrl;

export let version;


console.log('当前环境:', import.meta.env.VITE_NODE_ENV) 

if (import.meta.env.VITE_NODE_ENV === 'prod') {
	
  baseUrl = import.meta.env.VITE_BASE_URL;
  console.log('prod')
  console.log(baseUrl)
} else {
	
  baseUrl = import.meta.env.VITE_DEV_BASE_URL;
  console.log('dev')
  console.log(baseUrl)
}


export const apiPath = import.meta.env.VITE_API_PATH;
export const staticUrl = import.meta.env.VITE_STATIC_URL;

console.log(apiPath)

export default {
  baseUrl,
  apiPath,
};
