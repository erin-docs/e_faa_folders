
include: "/Models/e_faa_refinements.model.lkml"

explore: +aircraft {
  label: "Refined Aircraft"
  fields: [aircraft.aircraft_serial, aircraft.aircraft_model_code, aircraft.name, aircraft.count] # display fields
  }
