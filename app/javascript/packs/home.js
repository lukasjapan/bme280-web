console.log("home!");

// Vue
import Vue from 'vue'

// ElementUI
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-default'
import locale from 'element-ui/lib/locale/lang/en'

// Graphs
import TPHGraphs from 'tphgraphs'

document.addEventListener("DOMContentLoaded", function() {
    Vue.use(ElementUI, { locale })

    new Vue({
        el: '#graphs',
        render: h => h(TPHGraphs)
    });
});