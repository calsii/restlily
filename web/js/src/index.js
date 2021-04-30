import m from 'mithril'
import axios from 'axios'
import {viewFromData} from './pdf-viewer'

const exampleCode = `
\\version "2.22.1"
{
% middle tie looks funny here:
<c' d'' b''>8. ~ <c' d'' b''>8
}
`

const view = [
    m('div', {id: 'editor'}, [
        m('textarea', {id: 'code', textContent: exampleCode}),
        m('div', [
            m('canvas', {id: 'pdf'})
        ])
    ])
]

m.render(document.body, view)

axios({
    method: 'get',
    url: `http://localhost:8080/ly?code=${encodeURIComponent(exampleCode)}`,
    responseType: 'arraybuffer'
}).then(res => {
    viewFromData(res.data)
})
