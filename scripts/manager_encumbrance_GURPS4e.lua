--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	CharEncumbranceManager.addCustomCalc(CharEncumbranceManagerGURPS4e.calcEncumbrance);
end

function onTabletopInit()
	if Session.IsHost then
<<<<<<< HEAD
		DB.addHandler("charsheet.*.attributes.basiclift", "onUpdate",
			CharEncumbranceManagerGURPS4e.onBasicLiftChange);
=======
		DB.addHandler("charsheet.*.attributes.basiclift", "onUpdate", CharEncumbranceManagerGURPS4e.onBasicLiftChange);
>>>>>>> 88ac0df4d0ef5ea8c1430987a569f8e74ad5b978
		DB.addHandler("charsheet.*.attributes.halfmovedodge", "onUpdate",
			CharEncumbranceManagerGURPS4e.onHalfMoveDodgeChange);

		DB.addHandler("charsheet.*.encumbrance.enc0_weight", "onUpdate",
			CharEncumbranceManagerGURPS4e.onEncumbranceFieldChange);
		DB.addHandler("charsheet.*.encumbrance.enc1_weight", "onUpdate",
			CharEncumbranceManagerGURPS4e.onEncumbranceFieldChange);
		DB.addHandler("charsheet.*.encumbrance.enc2_weight", "onUpdate",
			CharEncumbranceManagerGURPS4e.onEncumbranceFieldChange);
		DB.addHandler("charsheet.*.encumbrance.enc3_weight", "onUpdate",
			CharEncumbranceManagerGURPS4e.onEncumbranceFieldChange);
		DB.addHandler("charsheet.*.encumbrance.enc4_weight", "onUpdate",
			CharEncumbranceManagerGURPS4e.onEncumbranceFieldChange);

		DB.addHandler("charsheet.*.encumbrance.enc0_dodge", "onUpdate",
			CharEncumbranceManagerGURPS4e.onDodgeFieldChange);
	end
end

function onHalfMoveDodgeChange(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharEncumbranceManagerGURPS4e.updateEncumbranceLevel(nodeChar);
end

function onBasicLiftChange(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharEncumbranceManagerGURPS4e.updateEncumbranceWeight(nodeChar);
	CharEncumbranceManagerGURPS4e.updateEncumbranceLevel(nodeChar);
end

function onEncumbranceFieldChange(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharEncumbranceManagerGURPS4e.updateEncumbranceLevel(nodeChar);
end

function onDodgeFieldChange(nodeField)
	local nodeChar = DB.getChild(nodeField, "...");
	CharEncumbranceManagerGURPS4e.updateDodgeField(nodeChar);
end

function calcEncumbrance(nodeChar)
	local nEncumbrance = CharEncumbranceManager.calcDefaultInventoryEncumbrance(nodeChar);
	nEncumbrance = nEncumbrance + CharEncumbranceManager.calcDefaultCurrencyEncumbrance(nodeChar);
	CharEncumbranceManager.setDefaultEncumbranceValue(nodeChar, nEncumbrance);

	CharEncumbranceManagerGURPS4e.updateEncumbranceLevel(nodeChar);
end

function updateEncumbranceLevel(nodeChar)
	if not DB.isOwner(nodeChar) then
		return;
	end

	local nodeEnc = DB.getChild(nodeChar, "encumbrance");
	local nEncNone = tonumber(string.match(DB.getValue(nodeEnc, "enc0_weight", "0"), "%d+")) or 0;
	local nEncLight = tonumber(string.match(DB.getValue(nodeEnc, "enc1_weight", "0"), "%d+")) or 0;
	local nEncMedium = tonumber(string.match(DB.getValue(nodeEnc, "enc2_weight", "0"), "%d+")) or 0;
	local nEncHeavy = tonumber(string.match(DB.getValue(nodeEnc, "enc3_weight", "0"), "%d+")) or 0;
	local nEncXHeavy = tonumber(string.match(DB.getValue(nodeEnc, "enc4_weight", "0"), "%d+")) or 0;

	-- These are the checkbox for encumberance level. All default to 0.
	DB.setValue(nodeEnc, "enc_0", "number", 0);
	DB.setValue(nodeEnc, "enc_1", "number", 0);
	DB.setValue(nodeEnc, "enc_2", "number", 0);
	DB.setValue(nodeEnc, "enc_3", "number", 0);
	DB.setValue(nodeEnc, "enc_4", "number", 0);

	local nTotal = DB.getValue(nodeEnc, "load", 0);
	if nTotal <= nEncNone then
		DB.setValue(nodeEnc, "level", "string", "None");
		DB.setValue(nodeEnc, "enc_0", "number", 1);
		DB.setValue(nodeChar, "attributes.move", "string", DB.getValue(nodeEnc, "enc0_move", "0"));
		DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeEnc, "enc0_dodge", 0));
	elseif nTotal <= nEncLight then
		DB.setValue(nodeEnc, "level", "string", "Light");
		DB.setValue(nodeEnc, "enc_1", "number", 1);
		DB.setValue(nodeChar, "attributes.move", "string", DB.getValue(nodeEnc, "enc1_move", "0"));
		DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeEnc, "enc1_dodge", 0));
	elseif nTotal <= nEncMedium then
		DB.setValue(nodeEnc, "level", "string", "Medium");
		DB.setValue(nodeEnc, "enc_2", "number", 1);
		DB.setValue(nodeChar, "attributes.move", "string", DB.getValue(nodeEnc, "enc2_move", "0"));
		DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeEnc, "enc2_dodge", 0));
	elseif nTotal <= nEncHeavy then
		DB.setValue(nodeEnc, "level", "string", "Heavy");
		DB.setValue(nodeEnc, "enc_3", "number", 1);
		DB.setValue(nodeChar, "attributes.move", "string", DB.getValue(nodeEnc, "enc3_move", "0"));
		DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeEnc, "enc3_dodge", 0));
	elseif nTotal <= nEncXHeavy then
		DB.setValue(nodeEnc, "level", "string", "X-Heavy");
		DB.setValue(nodeEnc, "enc_4", "number", 1);
		DB.setValue(nodeChar, "attributes.move", "string", DB.getValue(nodeEnc, "enc4_move", "0"));
		DB.setValue(nodeChar, "combat.dodge", "number", DB.getValue(nodeEnc, "enc4_dodge", 0));
	else
		DB.setValue(nodeEnc, "level", "string", "Overloaded");
		DB.setValue(nodeEnc, "enc_0", "number", 1);
		DB.setValue(nodeEnc, "enc_1", "number", 1);
		DB.setValue(nodeEnc, "enc_2", "number", 1);
		DB.setValue(nodeEnc, "enc_3", "number", 1);
		DB.setValue(nodeEnc, "enc_4", "number", 1);
		DB.setValue(nodeChar, "attributes.move", "string", "0");
		DB.setValue(nodeChar, "combat.dodge", "number", 3);
	end

	if DB.getValue(nodeChar, "attributes.halfmovedodge", 0) == 1 then
		local halfMove = math.ceil(tonumber(string.match(DB.getValue(nodeChar, "attributes.move", "0"), "%d+") or 0) / 2);
		local halfDodge = math.ceil(DB.getValue(nodeChar, "combat.dodge", 0) / 2);
		DB.setValue(nodeChar, "attributes.move", "string", halfMove);
		DB.setValue(nodeChar, "combat.dodge", "number", halfDodge);
	end
end

<<<<<<< HEAD
function updateEncumbranceWeight(nodeChar)
	if not DB.isOwner(nodeChar) then
		return;
	end

	local nodeAtt = DB.getChild(nodeChar, "attributes");
	local nBasicLift = math.max(
		tonumber(string.match(DB.getValue(nodeAtt, "basiclift", "13"), "%d+")) or 0
		, 0);
	
	local nodeEnc = DB.getChild(nodeChar, "encumbrance");
	DB.setValue(nodeEnc, "enc0_weight", "string", nBasicLift, 0);
	DB.setValue(nodeEnc, "enc1_weight", "string", nBasicLift * 2, 0);
	DB.setValue(nodeEnc, "enc2_weight", "string", nBasicLift * 3, 0);
	DB.setValue(nodeEnc, "enc3_weight", "string", nBasicLift * 6, 0);
	DB.setValue(nodeEnc, "enc4_weight", "string", nBasicLift * 10, 0);
end

=======
>>>>>>> 88ac0df4d0ef5ea8c1430987a569f8e74ad5b978
function updateDodgeField(nodeChar)
	if not DB.isOwner(nodeChar) then
		return;
	end

	local nodeEnc = DB.getChild(nodeChar, "encumbrance");
	local nEncDodge = tonumber(string.match(DB.getValue(nodeEnc, "enc0_dodge", "0"), "%d+")) or 0;
	DB.setValue(nodeEnc, "enc1_dodge", "number", math.max(nEncDodge - 1, 1));
	DB.setValue(nodeEnc, "enc2_dodge", "number", math.max(nEncDodge - 2, 1));
	DB.setValue(nodeEnc, "enc3_dodge", "number", math.max(nEncDodge - 3, 1));
<<<<<<< HEAD
	DB.setValue(nodeEnc, "enc4_dodge", "number", math.max(nEncDodge - 4, 1));
=======
	DB.setValue(nodeEnc, "enc4_dodge", "number", math.max(nEncDodge - 4, 1));	
>>>>>>> 88ac0df4d0ef5ea8c1430987a569f8e74ad5b978
end