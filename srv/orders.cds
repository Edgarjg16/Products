using com.training as training from '../db/training';

service ManageOrders {
    entity GetOrders    as projection on training.Orders;

    entity CreateOrders as projection on training.Orders;

    entity UpdateOrders as projection on training.Orders;

    entity DeleteOrders as projection on training.Orders;

    function getClientTaxRate(clientEmail: String(65)) returns Decimal(4, 2);
}
