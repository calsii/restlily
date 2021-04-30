const pdfjsLib = window['pdfjs-dist/build/pdf']
pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.8.335/pdf.worker.min.js'

export const viewFromData = data => {
    const loadingTask = pdfjsLib.getDocument({data})
    loadingTask.promise.then(function (pdf) {
        // console.log('PDF loaded')

        // Fetch the first page
        const pageNumber = 1
        pdf.getPage(pageNumber).then(function (page) {
            // console.log('Page loaded')

            const scale = 1
            let viewport = page.getViewport({scale})

            // Prepare canvas using PDF page dimensions
            let canvas = document.getElementById('pdf')
            let canvasContext = canvas.getContext('2d')
            canvas.height = viewport.height
            canvas.width = viewport.width

            // Render PDF page into canvas context
            const renderTask = page.render({canvasContext, viewport})
            renderTask.promise.then(function () {
                console.log('Page rendered')
            })
        })
    }, function (reason) {
        // PDF loading error
        console.error(reason)
    })
}

export default pdfjsLib
