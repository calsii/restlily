import m from 'mithril'
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

m.request({
    method: 'GET',
    url: 'http://localhost:8080/ly',
    params: {code: exampleCode},
    responseType: 'arraybuffer'
}).then(viewFromData)
