description = "Tools_to_CSV";
vendor = "Ian Rist";
vendorUrl = "";
legal = "Copyright (C) Ian Rist 2022";
certificationLevel = 2;

longDescription = "This script will output a CSV file of all the tools in the setup.";

extension = "csv";
// using user code page

capabilities = CAPABILITY_INTERMEDIATE;

allowMachineChangeOnSection = true;
allowHelicalMoves = true;
allowSpiralMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion
maximumCircularSweep = toRad(1000000);
minimumCircularRadius = spatial(0.001, MM);
maximumCircularRadius = spatial(1000000, MM);

// user-defined properties
properties = {
  justMillingParameters: true, // displays parameters
};

// user-defined property definitions
propertyDefinitions = {
  justMillingParameters: { title: "Show only Milling Tool Parameter", description: "If enabled, only Parameter relivant to milling tools will be recorded", type: "boolean" }
};

var spatialFormat = createFormat({ decimals: 6 });
var angularFormat = createFormat({ decimals: 6, scale: DEG });
var rpmFormat = createFormat({ decimals: 6 });
var otherFormat = createFormat({ decimals: 6 });

var expanding = false;

var already_recorded_tool = "b";

function toString(value) {
  if (typeof value == "string") {
    return value.replace(new RegExp('"', 'g'), "in");
  } else {
    return value;
  }
}

function onOpen() {
  if (properties.justMillingParameters) {
    writeln("toolId,number,diameterOffset,lengthOffset,secondaryLengthOffset,maximumSpindleSpeed,spindleRPM,rampingSpindleRPM,clockwise,numberOfFlutes,threadPitch,coolant,description,comment,vendor,productId,holderDescription,holderComment,holderVendor,holderProductId,unit,type,diameter,tipDiameter,cornerRadius,taperAngle,fluteLength,shoulderLength,shaftDiameter,bodyLength,overallLength,holderTipDiameter,holderDiameter,holderLength");
  }
  else {
    writeln("toolId,number,diameterOffset,lengthOffset,secondaryLengthOffset,turningTool,jetTool,holderNumber,surfaceSpeed,maximumSpindleSpeed,spindleRPM,rampingSpindleRPM,clockwise,numberOfFlutes,threadPitch,coolant,material,description,comment,vendor,productId,holderDescription,holderComment,holderVendor,holderProductId,aggregateId,unit,type,diameter,tipDiameter,cornerRadius,taperAngle,fluteLength,shoulderLength,shaftDiameter,bodyLength,overallLength,holderTipDiameter,holderDiameter,holderLength,boringBarOrientation,jetDistance,jetDiameter,kerfWidth,machineQualityControl,cutHeight,pierceHeight,pressure,pierceTime,abrasiveFlowRate,piercePower,cutPower,assistGas,compensationOffset,secondaryCompensationOffset,turret,insertType,holderType,compensationMode,inscribedCircleDiameter,edgeLength,noseRadius,reliefAngle,thickness,grooveWidth,crossSection,tolerance,pitch,hand,clamping,manualToolChange,breakControl,liveTool,tappingFeedrate");
  }
}

function ab(val) {
  return "a" + val + "b";
}

function onSection() {
  if (already_recorded_tool.indexOf(ab(tool.toolId)) == -1) {
    already_recorded_tool = already_recorded_tool + ab(tool.toolId);
    if (properties.justMillingParameters) {
      vars_list = tool.toolId + "," + tool.number + "," + tool.diameterOffset + "," + tool.lengthOffset + "," + tool.secondaryLengthOffset + "," + tool.maximumSpindleSpeed + "," + tool.spindleRPM + "," + tool.rampingSpindleRPM + "," + tool.clockwise + "," + tool.numberOfFlutes + "," + tool.threadPitch + "," + tool.coolant + "," + toString(tool.description) + "," + toString(tool.comment) + "," + toString(tool.vendor) + "," + toString(tool.productId) + "," + toString(tool.holderDescription) + "," + toString(tool.holderComment) + "," + toString(tool.holderVendor) + "," + toString(tool.holderProductId) + "," + tool.unit + "," + tool.type + "," + tool.diameter + "," + tool.tipDiameter + "," + tool.cornerRadius + "," + tool.taperAngle + "," + tool.fluteLength + "," + tool.shoulderLength + "," + tool.shaftDiameter + "," + tool.bodyLength + "," + tool.overallLength + "," + tool.holderTipDiameter + "," + tool.holderDiameter + "," + tool.holderLength
    }
    else {
      vars_list = tool.toolId + "," + tool.number + "," + tool.diameterOffset + "," + tool.lengthOffset + "," + tool.secondaryLengthOffset + "," + tool.turningTool + "," + tool.jetTool + "," + tool.holderNumber + "," + tool.surfaceSpeed + "," + tool.maximumSpindleSpeed + "," + tool.spindleRPM + "," + tool.rampingSpindleRPM + "," + tool.clockwise + "," + tool.numberOfFlutes + "," + tool.threadPitch + "," + tool.coolant + "," + tool.material + "," + toString(tool.description) + "," + toString(tool.comment) + "," + toString(tool.vendor) + "," + toString(tool.productId) + "," + toString(tool.holderDescription) + "," + toString(tool.holderComment) + "," + toString(tool.holderVendor) + "," + toString(tool.holderProductId) + "," + toString(tool.aggregateId) + "," + tool.unit + "," + tool.type + "," + tool.diameter + "," + tool.tipDiameter + "," + tool.cornerRadius + "," + tool.taperAngle + "," + tool.fluteLength + "," + tool.shoulderLength + "," + tool.shaftDiameter + "," + tool.bodyLength + "," + tool.overallLength + "," + tool.holderTipDiameter + "," + tool.holderDiameter + "," + tool.holderLength + "," + tool.boringBarOrientation + "," + tool.jetDistance + "," + tool.jetDiameter + "," + tool.kerfWidth + "," + tool.machineQualityControl + "," + tool.cutHeight + "," + tool.pierceHeight + "," + tool.pressure + "," + tool.pierceTime + "," + tool.abrasiveFlowRate + "," + tool.piercePower + "," + tool.cutPower + "," + tool.assistGas + "," + tool.compensationOffset + "," + tool.secondaryCompensationOffset + "," + tool.turret + "," + tool.insertType + "," + tool.holderType + "," + tool.compensationMode + "," + tool.inscribedCircleDiameter + "," + tool.edgeLength + "," + tool.noseRadius + "," + tool.reliefAngle + "," + tool.thickness + "," + tool.grooveWidth + "," + tool.crossSection + "," + tool.tolerance + "," + tool.pitch + "," + tool.hand + "," + tool.clamping + "," + tool.manualToolChange + "," + tool.breakControl + "," + tool.liveTool + "," + tool.tappingFeedrate
    }
    writeln(vars_list);
  }
  
}

function onRapid5D(_x, _y, _z, _a, _b, _c) { }
function onLinear5D(_x, _y, _z, _a, _b, _c, feed, feedMode) { }