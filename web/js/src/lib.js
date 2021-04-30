export const debounce = (func, timeout = 888) => {
  let timer
  return (...args) => {
    clearTimeout(timer)
    timer = setTimeout(() => { func.apply(this, args) }, timeout)
  };
}
