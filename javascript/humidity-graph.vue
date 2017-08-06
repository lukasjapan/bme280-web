<template>
    <div>
        <canvas id="humidity"></canvas>
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
            chartoptions() {
                return {
                    type: 'line',
                    data: {
                        labels: this.labels,
                        datasets: [{
                            label: "Humidity",
                            fill: false,
                            borderColor: 'blue',
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
                                    min: 0.0,
                                    max: 100.0
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: 'Humidity in %'
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
            }
        },
        mounted() {
            this.create()
        },
        methods: {
            create() {
                this.$chart = new Chart('humidity', this.chartoptions)
            },
            update() {
                this.$chart.data.labels = this.labels
                this.$chart.data.datasets[0].data = this.values
                this.$chart.options.scales.xAxes[0].time.min = this.xmin
                this.$chart.options.scales.xAxes[0].time.max = this.xmax
                this.$chart.update()
            }
        }
    }
</script>