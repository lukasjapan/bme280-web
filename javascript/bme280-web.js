// Vue
import Vue from 'vue'

// ElementUI
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-default/index.css'
import locale from 'element-ui/lib/locale/lang/en'

// Graphs
import TPHGraphs from './tphgraphs.vue'

document.addEventListener("DOMContentLoaded", function() {
    Vue.use(ElementUI, { locale })

    new Vue({
        el: '#bme280-web',
        render: h => h(TPHGraphs)
    });
});
