const fs = require('fs');
const { execSync } = require('child_process');

function parseFile(inputPath) {
    // Read the file.
    const data = fs.readFileSync(inputPath, 'utf8');
    
    // Regular expression to match the lines like: pub(super) fn function_name(&mut self)
    const regex = /pub\(super\) fn ([^\(]+)\(&mut self\)/g;

    let match;
    const functionNames = [];

    const dont_match = [
        'acc','imp','imm','zp0','zpx','zpy','rel','abs','abx','aby','ind','idx','idy'
    ]

    while ((match = regex.exec(data)) !== null) {
        if (!dont_match.includes(match[1])) {
            functionNames.push(match[1]);
        }
    }

    // Write files for each function name.
    for (const name of functionNames) {
        // Create new project using nargo
        execSync(`nargo new ${name}`);

        const content = `use dep::helpers;

fn check_op(
    r: Field,
    op_sorted_step: [Field; 21],
    op_sorted_addr: [Field; 21],
    op_sorted_val: [Field; 21],
    op_sorted_op_rw: [Field; 21]
) -> Field {
    // TODO: implemented mode retrieval here for the opcode read 
    // we don't generalize this because each opcode will only have a few modes
    // and we want to keep the total constraints down rather than needlessly
    // checking for other opcodes every time

    let mode: Field = 0; //stubbed for now, we assume the mode is retreived in logic above
    let mut sub_arr_step: [Field; 7] = [0,0,0,0,0,0,0];
    let mut sub_arr_addr: [Field; 7] = [0,0,0,0,0,0,0];
    let mut sub_arr_val: [Field; 7] = [0,0,0,0,0,0,0];
    let mut sub_arr_op_rw: [Field; 7] = [0,0,0,0,0,0,0];
    for i in 0..7 {
        sub_arr_step[i] = op_sorted_step[i];
        sub_arr_addr[i] = op_sorted_addr[i];
        sub_arr_val[i] = op_sorted_val[i];
        sub_arr_op_rw[i] = op_sorted_op_rw[i];
    }
    let address_and_value: [Field; 2] = helpers::get_addressing(
        mode,
        sub_arr_step,
        sub_arr_addr,
        sub_arr_val,
        sub_arr_op_rw
    );

    // TODO: implement the rest of the op code checks here

    // TODO: handle case of padding

    // Compute permutation and return it
    helpers::compute_permutation(
        r,
        op_sorted_step,
        op_sorted_addr,
        op_sorted_val,
        op_sorted_op_rw
    )
}`;

        fs.writeFileSync(`${name}/src/main.nr`, content);

        const newNargo = `[package]
name = "${name}"
type = "bin"
authors = [""]
compiler_version = "0.10.5"

[dependencies]
helpers= { path = "../../halpers" }
`
        // Overwriting Nargo.toml
        fs.writeFileSync(`${name}/Nargo.toml`, newNargo);
    }
}

// Taking input from the user for file path.
const filePath = process.argv[2];
parseFile(filePath);