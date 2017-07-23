<template>
    <div>
        <el-row>
            <el-col :md="12" v-loading="loading">
                <temperature-graph :data="t_data" :base="t.base" :range="t.range" :from="from" :to="to" />
            </el-col>
            <el-col :md="12">B</el-col>
            <el-col :md="12">C</el-col>
            <el-col :md="12">
                <el-form>
                    <el-form-item label="Latest">
                        <el-radio-group v-model="length">
                            <el-radio-button label="300">5m</el-radio-button>
                            <el-radio-button label="3600">1h</el-radio-button>
                            <el-radio-button label="43200">12h</el-radio-button>
                            <el-radio-button label="86400">1d</el-radio-button>
                            <el-radio-button label="604800">7d</el-radio-button>
                            <el-radio-button label="2592000">1m</el-radio-button>
                            <el-radio-button label="15768000">6m</el-radio-button>
                            <el-radio-button label="31536000">1y</el-radio-button>
                        </el-radio-group>
                    </el-form-item>
                    <el-form-item label="Time range">
                        <el-date-picker v-model="range" type="datetimerange" placeholder=""></el-date-picker>
                    </el-form-item>
                    <el-form-item label="Temperature Range">
                        <el-input-number v-model="t.base"></el-input-number>
                        &plusmn;
                        <el-input-number v-model="t.range"></el-input-number>
                    </el-form-item>
                </el-form>
            </el-col>
        </el-row>
    </div>
</template>
<script>
    import TemperatureGraph from 'temperature-graph'
    import axios from 'axios'

    export default {
        components: { TemperatureGraph },
        data() {
            return {
                length: 300,
                t: {
                    base: 20,
                    range: 30
                },
                loading: true,
                t_data: {},
                to: null,
                from: null,
                range: [ null, null ],
                // [ callback, seconds ] to enable an interval or null to disable
                interval: null
            }
        },
        mounted() {
            this.loadLatest(this.length)
        },
        watch: {
            length() {
                if(this.length > 0) {
                    this.loadLatest(this.length)
                }
            },
            range() {
                if(this.range[0] && this.range[1]) {
                    this.loadRange(this.range[0], this.range[1])
                }
            },
            interval() {
                if(this.$interval) {
                    clearInterval(this.$interval)
                }

                if(this.interval) {
                    let callback = this.interval[0]
                    let seconds = this.interval[1]
                    this.$interval = setInterval(callback, seconds * 1000)
                }
            }
        },
        methods: {
            loadLatest(length) {
                this.loading = true
                this.interval = null
                this.range = [ null, null ]

                axios.get('/latest.json', { params: { s: length } })
                    .then((response) => {
                        let now = new Date()
                        this.updateGraphData(new Date(now - length * 1000), now, response.data)
                        this.loading = false
                        this.interval = [ () => { this.loadLatest(length) }, length / 300 ]
                    })
                    .catch((error) => {
                        alert(error);
                    });
            },
            loadRange(from, to) {
                this.loading = true
                this.interval = null
                this.length = 0

                axios.get('/range.json', { params: { from: from, to: to } })
                    .then((response) => {
                        this.updateGraphData(from, to, response.data)
                        this.loading = false
                        this.interval = [ () => { this.loadRange(from, to) }, Math.round((to - from) / 300000) ]
                    })
                    .catch((error) => {
                        alert(error);
                    });
            },
            updateGraphData(from, to, data) {
                let t_data = {}
                let p_data = {}
                let h_data = {}

                for(let record of data) {
                    t_data[record.ts] = record.t
                    p_data[record.ts] = record.p
                    h_data[record.ts] = record.h
                }

                this.from = from
                this.to = to
                this.t_data = t_data
//                this.p_data = p_data
//                this.h_data = h_data
            }
        }
    }
</script>