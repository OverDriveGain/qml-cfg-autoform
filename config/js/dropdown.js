function pushValue(dropDown, value) {
	const tempModel = dropDown.model
	tempModel.push({
					   "text": value,
					   "value": value
				   })
	dropDown.model = []
	dropDown.model = tempModel //.push({
}
function convertListToHeaders(headers) {
	const headersArr = []
	headers.forEach(el => {
						headersArr.push({
											"text": el,
											"value": el
										})
					})
	return headersArr
}
function mapDropdownTextToIndex(list, value) {
	let return_value = -1
	list.forEach((el, index) => {
					 if (el.text && el.text === value) {
						 return_value = index
					 } else if (el === value)
					 return_value = index
				 })
	return return_value
}

function mapDropdownModelToIndex(delegateModel, model, key, value) {
	let return_value = -1
	for (var i = 0; i < model.rowCount() && delegateModel; i++) {
		const modelIndex = delegateModel.modelIndex(i)
		const item = model.getItemAttr(modelIndex, key)
		if (item === value) {
			return_value = i
		}
	}
	return return_value
}

