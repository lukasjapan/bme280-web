<template>
    <div>
        <canvas id="temperature"></canvas>
    </div>
</template>
<script type="text/ecmascript-6">
    import Chart from 'chart.js'

    export default {
        props: {
            data: {
                type: Object,
                default: {}
            },
            base: {
                type: Number,
                default: 20
            },
            range: {
                type: Number,
                default: 30
            },
            from: {
                type: Date,
            },
            to: {
                type: Date,
            }
        },
        data() {
            return {
                $chart: null
            }
        },
        computed: {
            labels() {
                return Object.keys(this.data).map((ts) => { return new Date(ts * 1000) })
            },
            values() {
                return Object.values(this.data)
            },
            xmin() {
                return this.from
            },
            xmax() {
                return this.to
            },
            ymin() {
                return this.base - this.range
            },
            ymax() {
                return this.base + this.range
            },
            chartoptions() {
                return {
                    type: 'line',
                    data: {
                        labels: this.labels,
                        datasets: [{
                            label: "Temperature",
                            fill: false,
                            borderColor: 'red',
                            data: this.values
                        }]
                    },
                    options: {
                        animation: false,
                        responsive: true,
                        scales: {
                            xAxes: [{
                                type: 'time',
                                time: {
                                    //unit: 'second',
                                    //unitStepSize: 1,
                                    displayFormats: {
                                        'second': 'HH:mm:ss'
                                    },
                                    min: this.xmin,
                                    max: this.xmax,
                                },
                                ticks: {
                                    maxRotation: 45,
                                    minRotation: 45
                                },
                                display: true,
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Time'
                                }
                            }],
                            yAxes: [{
                                display: true,
                                ticks: {
                                    min: this.ymin,
                                    max: this.ymax
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Temperature in °C'
                                }
                            }]
                        },
                        elements: {
                            point: {
                                radius: 0
                            }
                        },
                        legend: {
                            display: false
                        }
                    }
                }
            }
        },
        watch: {
            data() {
                this.update()
            },
            base() {
                this.update()
            },
            range() {
                this.update()
            }
        },
        mounted() {
            this.create()
        },
        methods: {
            create() {
                this.$chart = new Chart('temperature', this.chartoptions)
            },
            update() {
                this.$chart.data.labels = this.labels
                this.$chart.data.datasets[0].data = this.values
                this.$chart.options.scales.xAxes[0].time.min = this.xmin
                this.$chart.options.scales.xAxes[0].time.max = this.xmax
                this.$chart.options.scales.yAxes[0].ticks.min = this.ymin
                this.$chart.options.scales.yAxes[0].ticks.max = this.ymax
                this.$chart.update()
            }
        }
    }
</script>