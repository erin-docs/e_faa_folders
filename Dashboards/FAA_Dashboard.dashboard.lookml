- dashboard: faa_dashboard
  title: FAA Dashboard
  layout: newspaper
  elements:
  - title: FAA dashboard
    name: FAA dashboard
    model: e_faa_flights
    explore: airport_remarks
    type: table
    fields: [airport_remarks.airport_remark_id, airport_remarks.site_number, airport_remarks.count]
    sorts: [airport_remarks.count desc]
    limit: 500
    row: 0
    col: 0
    width: 8
    height: 6
