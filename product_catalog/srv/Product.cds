using{ com.catalogProd as catalog } from '../db/schema';

service Productservice {
    entity ProductSrv as projection on catalog.Product;
}
