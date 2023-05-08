const text = {
  "quote": "quote",
  "rfq": "RFQ",
  "invoice": "invoice",
  "pn": "Part Number",
  "qty": "Quantity",
  "cond": "Condition",
  "mfg": "Manufacturer"
}

function numberWithCommas(n) {
  var parts = n.toString().split(".")
  return (parts[0].replace(
            /\B(?=(\d{3})+(?!\d))/g,
            ",") + (parts.length > 1 ? "." + parts[1] : "")).replace(/,,/g, ',')
}

function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}