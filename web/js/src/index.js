import m from 'mithril'
import {generatePdf, updaetPdf} from './pdf-viewer'
import { demoCode } from './config'

let code = demoCode

const app = {
    view () {
        return m('div#editor', [
            m('textarea#code', {
                textContent: code,
                oninput (e) {
                    code = e.target.value
                    updaetPdf(code)
                }
            }),
            m('div', [
                m('canvas#pdf')
            ])
        ])
    },
    oncreate () {
        generatePdf(code)
    }
}

m.render(document.body, m(app))
