#! /usr/bin/node

const fs = require("node:fs")

function main() {
    if (fs.existsSync("./backend")) {
        console.error("ERROR: A folder named backend already exists")
    }

    // Setup folder structure
    console.log("\nSetting up project structure...")
    fs.mkdirSync("./backend")
    fs.mkdirSync("./backend/src")
    fs.mkdirSync("./backend/src/features")
    fs.mkdirSync("./backend/src/utils")
    fs.mkdirSync("./backend/src/middlewares")

    // Setup prettier
    console.log("\nSetting up prettier...")
    const prettierrcContent = {
        semi: true,
        singleQuote: false,
        printWidth: 80,
        tabWidth: 4
    }
    const content = JSON.stringify(prettierrcContent, null, 4)
    fsWriteFile("./backend/.prettierrc.json", content);
    console.log("SUCCESS: Successfully created .prettierrc.json file");

    // Create .env file with basic variables
    console.log("\nSetting up secrets...")
    const envContent = `DB_URL=""\nSESSIONS_SECRET=""\nNODE_ENV="developemnt"`
    fsWriteFile("./backend/.env", envContent)
    console.log("SUCCESS: Successfully created .env file");

    // Create app.js and index.js with code
}

function fsWriteFile(filename, fileContent) {
    fs.writeFileSync(filename, fileContent, (err) => {
        if (err) {
            console.log(`ERROR: Unable to create ${filename} file`, err.message);
        } 
    })
}

main()
