#! /usr/bin/sh

# Create a new folder "server"
mkdir server

# TODO: Initialize project with "yarn init -y"
# TODO: Install necessary dependencies

# Create a sub folder "src" inside server folder
cd server
mkdir src

# Create subfolders "features" "utils" "middlewares" inside "src"
cd src
mkdir features middlewares utils

# Create files app.js and index.js along with code inside "src"
touch app.js index.js

app_code=$(cat<<EOF
import express from "express"
import helmet from "helmet"
import hpp from "hpp"
import morgan from "morgan"
import cors from "cors"
import { catch404, globalErrorHandler } from "./utils/errorHandlers.js";

const app = express();

app.use(helmet())
app.use(hpp())
app.use(morgan("dev"))
app.use(cors({
    origin: process.env.FRONTEND_URL,
    credentials: true
}))
app.use(express.json())
app.use(express.urlencoded({ extended: false }))

// ROUTES

// ERROR HANDLERS
app.use(catch404);
app.use(globalErrorHandler);

export default app;

EOF
)

index_code=$(cat << EOF
import app from "./app.js"
import { connectDB } from "./utils/db.js"

async function startServer() {
    await connectDB(process.env.DB_URL);
    app.listen(8000, () => {
        console.log("express server started on port 8000")
    })
}

startServer()
EOF
)

dbjs_code=$(cat << EOF
import mongoose from "mongoose";

export async function connectDB(url) {
    await mongoose.connect(url);
    console.log("DB Connected")
}

export async function disconnectDB() {
    await mongoose.disconnect();
    console.log("DB Disconnected")
}
EOF
)

apierror_code=$(cat << EOF
class ApiError {
    constructor(messgae, status) {
        this.message = message;
        this.status = status;
        Error.captureStackTrace(this);
    }
}

export default ApiError;
EOF
)

errorHandlers_code=$(cat << EOF
export function catch404(req, res, next) {
    return next(new ApiError("Page not found", 404))
}

export function globalErrorHandler(err, req, res, next) {
    const errMsg = err.message;
    const status = err.status;

    if (process.env.NODE_ENV === "development") {
        res.status(status).json({
            ok: true,
            error: errMsg,
            stack: err.stack
        })
    } else {
        res.status(status).json({
            ok: true,
            error: errMsg
        })
    }
}
EOF
)

echo "$app_code" > "app.js"
echo "$index_code" > "index.js"
echo "$apierror_code" > "./utils/ApiError.js"
echo "$errorHandlers_code" > "./utils/errorHandlers.js"
echo "$dbjs_code" > "./utils/db.js"
