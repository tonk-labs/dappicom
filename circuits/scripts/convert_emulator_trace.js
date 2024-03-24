const fs = require('fs');

function readJsonFile(filename) {
    const fileContent = fs.readFileSync(filename, 'utf-8');
    return JSON.parse(fileContent);
}

function splitIntoSegments(data) {
    const segments = [];
    let currentSegment = [];

    for (const entry of data) {
        if (entry.etype === 'DELIMITER') {
            if (currentSegment.length) {
                updateAddrBasedOnEtype(currentSegment);
                segments.push(currentSegment);
                currentSegment = [];
            }
        } else {
            currentSegment.push(entry);
        }
    }

    // Add any remaining segment
    if (currentSegment.length) {
        updateAddrBasedOnEtype(currentSegment);
        segments.push(currentSegment);
    }

    return segments;
}

const etypeToAddrMapping = {
    'PC': 8203,
    'X': 8201,
    'Y': 8202,
    'A': 8200,
    'S': 8205,
    'SP': 8204
}

function updateAddrBasedOnEtype(segment) {
    for (const entry of segment) {
        if (etypeToAddrMapping[entry.etype] !== undefined) {
            entry.addr = etypeToAddrMapping[entry.etype];
        }
    }
}

function convertSegment(segment) {
    const step = [], addr = [], val = [], op_rw = [];
    for (const entry of segment) {
        step.push(entry.step);
        addr.push(entry.addr);
        val.push(entry.val);
        op_rw.push(entry.op_rw == 'Read' ? 0 : 1);
    }
    return { step, addr, val, op_rw };
}

function templateSegment(segmentData, index) {
    return `
#[test]
fn test_${index}() -> Field {
    main(
        1, 
        [${segmentData.step.join(", ")}], 
        [${segmentData.addr.join(", ")}], 
        [${segmentData.val.join(", ")}], 
        [${segmentData.op_rw.join(", ")}]
    )
}`;
}

function main() {
    const filePath = process.argv[2];
    const jsonData = readJsonFile(filePath);
    const segments = splitIntoSegments(jsonData);
    let output = "";

    for (let i = 0; i < segments.length; i++) {
        const segmentData = convertSegment(segments[i]);
        output += templateSegment(segmentData, i);
    }

    console.log(output);
}

main();