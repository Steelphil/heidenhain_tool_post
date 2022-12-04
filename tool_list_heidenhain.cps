description = "Tools_to_HH";
vendor = "Ian Rist";
vendorUrl = "";
legal = "Copyright (C) Ian Rist 2022";
certificationLevel = 2;

longDescription = "This script will output a Heidenhain gcode (.h) file to configure all the tools in the setup on a Heidenhain machine.";

extension = "h";
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
  magazineLoad: true, // displays parameters
};

// user-defined property definitions
propertyDefinitions = {
  magazineLoad: { title: "Load Tools into Magazine", description: "If enabled, the PLC expects the tool to be loaded into the magazine", type: "boolean" }
};

var spatialFormat = createFormat({ decimals: 6 });
var angularFormat = createFormat({ decimals: 6, scale: DEG });
var rpmFormat = createFormat({ decimals: 6 });
var otherFormat = createFormat({ decimals: 6 });

var expanding = false;

var already_recorded_tool = "b";

var spindleNoseOffset = 0;

function toString(value) {
  if (typeof value == "string") {
    return value.replace(new RegExp('"', 'g'), "in");
  } else {
    return value;
  }
}

function onOpen() {
  writeln("");
  
}

function ab(val) {
  return "a" + val + "b";
}

function onSection() {
  if (already_recorded_tool.indexOf(ab(tool.toolId)) == -1) { // this is really fucking stupid but the postprocessor system has no .includes() function for arrays
    already_recorded_tool = already_recorded_tool + ab(tool.toolId);
    
    writeln(";");
    writeln("* - LOAD TOOL DATA INTO TOOL.T");
    writeln("QS0 = " + tool.number + "; TOOL NUMBER");
    writeln("QS1 = \"" + tool.description + "\"; TOOL NAME");
    writeln("QS2 = \"" + tool.productId + "\"; DOCUMENT");
    writeln("QS4 = \"" + (tool.overallLength - spindleNoseOffset) + "\"; LENGTH"); // subtract the spindle nose offset to get true overall length
    writeln("QS5 = \"" + (tool.diameter / 2.0) + "\"; RADIUS");
    writeln("QS6 = \"" + tool.cornerRadius + "\"; CORNER RADIUS");
    writeln("QS7 = \"" + 6000 + "\"; LIFE MAX"); // TODO: add life max
    writeln("QS8 = \"" + 99 + "\"; TOOL TYPE"); // TODO: add tool type
    writeln("QS9 = \"" + tool.fluteLength + "\"; LENGTH OF CUT");
    writeln("QS11 = \"" + 0.05 + "\"; LENGTH TOLERANCE");
    writeln("QS12 = \"" + 0.05 + "\"; RADIUS TOLERANCE");
    writeln("QS13 = \"" + 1 + "\"; BROKEN LENGTH TOLERANCE");
    writeln("QS14 = \"" + 0.1 + "\"; BROKEN RADIUS TOLERANCE");
    writeln("QS16 = \"" + 0 + "\"; POINT ANGLE"); // TODO: add point angle, i assume this is drill tip angle
    writeln("QS17 = \"" + tool.threadPitch + "\"; THREAD PITCH");
    if (properties.magazineLoad) { // if the user wants to load the tool into the magazine we tell the PLC to expect that
      writeln("QS18 = \"" + 1 + "\"; PLC VALUE");
    } else {
      writeln("QS18 = \"" + 0 + "\"; PLC VALUE");
    }
    writeln("QS19 = \"" + tool.numberOfFlutes + "\"; NUMBER OF FLUTES");
    writeln("QS20 = \"" + 0 + "\"; MEASUREMENT RADIAL OFFSET");
    writeln("QS21 = \"" + 0 + "\"; MEASUREMENT LENGTH OFFSET");
    writeln("QS22 = \"user\"; PROGRAMMER");
    writeln("QS23 = \"Program name.h\"; NC-PGM");
    writeln(";");
    tablePath = "DATA WRITE \"\\TABLE\\TOOL\\T\\" + tool.number + "\\";
    writeln(tablePath + "NAME\" = QS1");
    writeln(tablePath + "DOC\" = QS2");
    writeln(tablePath + "L\" = QS4");
    writeln(tablePath + "R\" = QS5");
    writeln(tablePath + "R2\" = QS6");
    writeln(tablePath + "TIME2\" = QS7");
    writeln(tablePath + "TYP\" = QS8");
    writeln(tablePath + "LCUTS\" = QS9");
    writeln(tablePath + "LTOL\" = QS11");
    writeln(tablePath + "RTOL\" = QS12");
    writeln(tablePath + "LBREAK\" = QS13");
    writeln(tablePath + "RBREAK\" = QS14");
    writeln(tablePath + "T-ANGLE\" = QS16");
    writeln(tablePath + "PITCH\" = QS17");
    writeln(tablePath + "PLC-VAL\" = QS18");
    writeln(";");


  }
  
}

