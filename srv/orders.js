import cds from "@sap/cds";

const { SELECT, INSERT, UPDATE, DELETE } = cds.ql;
const { Orders } = cds.entities("com.training");

export default (srv) => {

    srv.before("*", (req) => {
        console.log(`Method: ${req.method}`);
        console.log(`Target: ${req.target}`);
    });

    //*******READ***********/
    srv.on("READ", "GetOrders", async (req) => {

        if (req.data.ClientEmail !== undefined) {
            return await SELECT.from`com.training.Orders`
                .where`ClientEmail: ${req.data.ClientEmail}`;
        }
        return await SELECT.from(Orders);
    });

    srv.after("READ", "GetOrders", (data) => {
        data.map((order) => (order.Reviewed = true));
    });

    srv.before("CREATE", "CreateOrders", (req) => {
        req.data.CreateOn = new req.Date().toISOString().slice(0, 10);
        console.log("CreateOn:", req.data.CreateOn);
        return req;
    });

    //******* CREATE **************/
    srv.on("CREATE", "CreateOrders", async (req) => {
        let returnData = await cds
            .transaction(req)
            .run(
                insert.into(Orders).entries({
                    ClientEmail: req.data.ClientEmail,
                    FirstName: req.data.FirstName,
                    LastName: req.data.LastName,
                    CreateOn: req.data.CreateOn,
                    Reviewed: req.data.Reviewed,
                    Approved: req.data.Approved,
                })
            )
            .then((resolve, reject) => {
                console.log("Resolve", resolve);
                console.log("Reject", reject);

                if (typeof resolve !== "undefined") {
                    return req.data;
                }
                else {
                    req.error(409, "Record Not Inserted");
                }
            })
            .catch((err) => {
                console.log(err);
                req.error(err.code, err.message);
            });
        console.log("Before End", returnData);
        return returnData;
    });

    // ******** UPDATE ********
    srv.on("UPDATE", "UpdateOrders", async (req) => {

        const result = await cds
            .transaction(req)
            .run(
                UPDATE(Orders)
                    .set({
                        FirstName: req.data.FirstName,
                        LastName: req.data.LastName,
                        Reviewed: req.data.Reviewed,
                        Approved: req.data.Approved
                    })
                    .where({
                        ClientEmail: req.data.ClientEmail
                    })
            );

        console.log("Registro actualizado:", result);

        return req.data;
    });

    // ******** DELETE ********
    srv.on("DELETE", "DeleteOrders", async (req) => {

        const result = await cds
            .transaction(req)
            .run(
                DELETE.from(Orders)
                    .where({
                        ClientEmail: req.data.ClientEmail
                    })
            );

        console.log("Registro eliminado:", result);

        return req.data;
    });

    //******** FUNTION ********
    srv.on("getClientTaxRate", async (req) => {
        const { clientEmail } = req.data;

        const db = cds.transaction(req);

        const result = await db
            .read(Orders)
            .columns("Country_code")
            .where({
                ClientEmail: clientEmail
            });

        if (!result || result.length === 0) {
            req.error(404,
                `Cliente ${clientEmail} no encontrado`
            );
            return;
        }

        console.log("Country_code:", result[0].Country_code);

        switch (result[0].Country_code) {

            case "UK":
                return 25.50;

            case "ES":
                return 26.60;

            default:
                return 99;
        }
    });

    // ************** ACTION ***********************/
    srv.on("cancelOrder", async (req) => {
        const { clientEmail } = req.data;
        const db = cds.transaction(req);
        const resultRead = await db.run(
            SELECT.from("com.training.Orders")
                .columns(
                    "ClientEmail",
                    "FirstName",
                    "LastName",
                    "Approved"
                )
                .where({
                    ClientEmail: clientEmail
                })
        );
        console.log("ClientEmail:", clientEmail);
        console.log("Result:", resultRead);
        if (!resultRead || resultRead.length === 0) {
            req.error(
                404,
                `Cliente ${clientEmail} no encontrado`
            );
            return;
        }
        const order = resultRead[0];
        if (order.Approved === false) {
            await db.run(
                UPDATE("com.training.Orders")
                    .set({
                        Status: "C"
                    })
                    .where({
                        ClientEmail: clientEmail
                    })
            );
            console.log("Action cancelOrder executed");
            return {
                status: "Succeeded",
                message: `The Order placed by ${order.FirstName} ${order.LastName} was cancelled`
            };
        } else {
            return {
                status: "Failed",
                message: `The Order placed by ${order.FirstName} ${order.LastName} was NOT cancelled`
            };
        }
    });
};