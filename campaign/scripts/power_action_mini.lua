-- 
-- Please see the license.txt file included with this distribution for 
-- attribution and copyright information.
--

local updateDisplayOriginal;
local updateViewsOriginal;

function onInit()
	updateDisplayOriginal = super.updateDisplay;
	super.updateDisplay = updateDisplay;

	updateViewsOriginal = super.updateViews;
	super.updateViews = updateViews;

	super.onInit();

	button.onWheel = onWheel;
end

function updateDisplay()
	updateDisplayOriginal();
	
	local node = getDatabaseNode();
	local sType = DB.getValue(node, "type", "");
	
	if sType == "resource" then
		button.setIcons("button_action_modifier", "button_action_modifier_down");
	end
end

function updateViews()
	updateViewsOriginal();
	
	local sType = DB.getValue(getDatabaseNode(), "type", "");
	if sType == "resource" then
		onResourceChanged();
	end
end

function onResourceChanged()
	local sResource = PowerManagerCg.getPCPowerResourceActionText(getDatabaseNode());
	button.setTooltipText("RESOURCE: " .. sResource);
end

function onWheel(notches)
	local node = getDatabaseNode();
	if Input.isControlPressed() and DB.getValue(node, "type", "") == "resource" then
		if DB.getValue(node, "variable", 0) == 1 then
			local nModifier = DB.getValue(node, "modifier", 0);
			local nMin = DB.getValue(node, "min", 0);
			local nMax = DB.getValue(node, "max", 0);
			local nInternval = DB.getValue(node, "interval", 0);
			nModifier = nModifier + (notches * nInternval);
			nModifier = math.max(nMin, nModifier);
			if nMax > 0 then
				nModifier = math.min(nMax, nModifier);
			end
			DB.setValue(node, "modifier", "number", nModifier);
		end
	end
	return true;
end