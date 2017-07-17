# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $.getJSON("latest.json", (json) ->
    labels = []
    data = { t: [], p: [], h: [] }
  
    for record in json
      labels.push(record.ts*1000)
      data.t.push(record.t)
      data.p.push(record.p)
      data.h.push(record.h)
    
    options = {
        animation: false,
        responsive: true,
        scales: {
            xAxes: [{
                type: 'time',
                time: {
                  unit: 'second',
                  unitStepSize: 1,
                  displayFormats: {
                    'second': 'HH:mm:ss'
                  }
                }
                display: true,
                scaleLabel: {
                    display: true,
                    labelString: 'Time'
                }
            }],
            yAxes: []
        },
        elements: {
                    point:{
                        radius: 0
                    }
                },
        legend: {
          display: false
        },
    };
    
    options.scales.yAxes = [{
                display: true,
                ticks: {
                    suggestedMin: -10,
                    suggestedMax: 50
                },
                scaleLabel: {
                    display: true,
                    labelString: 'Temperature in °C'
                }
            }]
    
    new Chart('temperature-rt', {
        # The type of chart we want to create
        type: 'line',
    
        # The data for our dataset
        data: {
            labels: labels,
            datasets: [{
                label: "Temperature",
                fill: false,
                borderColor: 'red',
                data: data.t
            }]
        },
    
        # Configuration options go here
        options: options
    });
    
    options.scales.yAxes = [{
                display: true,
                ticks: {
                    suggestedMin: 900,
                    suggestedMax: 1100
                },
                scaleLabel: {
                    display: true,
                    labelString: 'Pressure in hPa'
                }
            }]
    
    new Chart('pressure-rt', {
        # The type of chart we want to create
        type: 'line',
    
        # The data for our dataset
        data: {
            labels: labels,
            datasets: [{
                label: "Pressure",
                fill: false,
                borderColor: 'green',
                data: data.p
            }]
        },
    
        # Configuration options go here
        options: options
    });
    
    options.scales.yAxes = [{
                display: true,
                ticks: {
                    suggestedMin: 0,
                    suggestedMax: 100
                },
                scaleLabel: {
                    display: true,
                    labelString: 'Humidity in %'
                }
            }]
    
    new Chart('humidity-rt', {
        # The type of chart we want to create
        type: 'line',
    
        # The data for our dataset
        data: {
            labels: labels,
            datasets: [{
                label: "Humidity",
                fill: false,
                borderColor: 'blue',
                data: data.h
            }]
        },
    
        # Configuration options go here
        options: options
    });
  )