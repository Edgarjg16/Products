using com.training as training from '../db/training';

@impl: './orders.js'

service ManageOrders {

    type cancelOrderReturn {
        status : String enum {
            Succeeded;
            Failed
        }
    };


    entity GetOrders    as projection on training.Orders;

    entity CreateOrders as projection on training.Orders;

    entity UpdateOrders as projection on training.Orders;

    entity DeleteOrders as projection on training.Orders;

    // function getClientTaxRate(clientEmail: String(65)) returns Decimal(4, 2);

    // action   cancelOrder(clientEmail: String(65))      returns cancelOrderReturn;

    entity Orders       as projection on training.Orders
        actions {
            function getClientTaxRate(clientEmail: String(65)) returns Decimal(4, 2);

            action   cancelOrder(clientEmail: String(65))      returns cancelOrderReturn;
        }
}
