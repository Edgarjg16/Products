import cds from "@sap/cds";
import cors from "cors";
import adapterProxy from "@sap/cds-odata-v2-adapter-proxy";
import dotenv from "dotenv";
import swagger from "cds-swagger-ui-express";

dotenv.config();

cds.on("bootstrap", (app) => {
    app.use(adapterProxy());
    app.use(cors());

    app.get("/alive", (_, res) => {
        res.status(200).send("Server is Alive");
    });

    if (process.env.NODE_ENV !== 'production') {
        app.use(swagger());
    }
});

export default cds.server;