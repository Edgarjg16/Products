namespace com.logali;

using {
    cuid,
    managed
} from '@sap/cds/common';

type Name : String(50);

type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};

type Dec  : Decimal(16, 2);

context materials {
    entity Products : cuid, managed {
        Name             : String not null;
        Description      : localized String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now;
        DiscontinuedDate : DateTime;
        Price            : Dec;
        Height           : type of Price;
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        Supplier         : Association to one sales.Suppliers;
        UnitOfMeasure    : Association to UnitOfMeasures;
        Currency         : Association to Currencies;
        DimensionUnit    : Association to DimensionUnits;
        Category         : Association to Categories;
        SalesData        : Association to many sales.SalesData
                               on SalesData.Product = $self;
        Reviews          : Association to many ProductReviews
                               on Reviews.Product = $self;
    };

    entity Categories {
        key ID   : String(1);
            Name : localized String;
    };

    entity StockAvailability {
        key ID          : Integer;
            Description : localized String;
            Product     : Association to Products;
    };

    entity Currencies {
        key ID          : String(3);
            Description : localized String;
    };

    entity UnitOfMeasures {
        key ID          : String(2);
            Description : localized String;
    };

    entity DimensionUnits {
        key ID          : String(2);
            Description : localized String;
    };

    entity ProductReviews : cuid {
        ToProduct_Id : UUID;
        Created      : DateTime;
        Name         : String;
        Rating       : Integer;
        comment      : String;
        Product      : Association to Products;
    };

    entity ProjProducts  as projection on Products;

    entity ProjProducts2 as
        projection on Products {
            *
        };

    entity ProjProducts3 as
        projection on Products {
            ReleaseDate,
            Name
        };

    extend Products with {
        PriceCondition     : String(2);
        PriceDetermination : String(3);
    }
}

context sales {
    entity Orders : cuid, managed {
        // key ID       : UUID;
        Date     : Date;
        Customer : String;
        Item     : Composition of many OrderItems
                       on Item.Order = $self;
    }

    entity OrderItems : cuid, managed {
        // key ID       : UUID;
        Order    : Association to Orders;
        Products : Association to materials.Products;
        Quantity : Integer;
    }

    entity Suppliers : cuid, managed {
        Name     : type of materials.Products : Name;
        Address  : Address;
        Email    : String;
        Phone    : String;
        Fax      : String;
        Products : Association to many materials.Products
                       on $self = Products.Supplier;
    };

    entity Months {
        key ID               : String(2);
            Description      : localized String;
            ShortDescription : localized String(3);
    };

    entity SelProducts  as select from materials.Products;

    entity SelProducts1 as
        select from materials.Products {
            *
        };

    entity SelProducts2 as
        select from materials.Products {
            Name,
            Price,
            Quantity
        };

    entity SelProducts3 as
        select from materials.Products
        left join materials.ProductReviews
            on Products.Name = ProductReviews.Name
        {
            Rating,
            Products.Name,
            sum(Price) as TotalPrice
        }
        group by
            Rating,
            Products.Name
        order by
            Rating;

    entity SalesData : cuid, managed {
        DeliveryDate  : UUID;
        Revenue       : Decimal(16, 2);
        Product       : Association to materials.Products;
        Currency      : Association to materials.Currencies;
        DeliveryMonth : Association to sales.Months;
    };

}

context Reports {
    entity AverageRating as
        select from logali.materials.ProductReviews {
            Product.ID  as ProductId,
            avg(Rating) as AverageRating : Decimal(16, 2)
        }
        group by
            Product.ID;

    entity Products      as
        select from logali.materials.Products
        mixin {
            ToStockAvailability : Association to logali.materials.StockAvailability
                                      on ToStockAvailability.ID = $projection.StockAvailability;

            ToAverageRating     : Association to AverageRating
                                      on ToAverageRating.ProductId = ID;
        }
        into {
            *,
            ToAverageRating.AverageRating as Rating,
            case
                when Quantity >= 8
                     then 8
                when Quantity > 0
                     then 2
                else 1
            end                           as StockAvailability : Integer,
            ToStockAvailability
        }
}
