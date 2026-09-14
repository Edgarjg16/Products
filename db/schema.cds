namespace com.logali;

type Name : String(50);

type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};

// Comentar Ctrl + K + C
// Descomentar Ctrl K U
// type EmailsAddresses_01 : many {
//     Kind  : String;
//     email : String;
// };

// type EmailsAddresses_02 : array of {
//     Kind  : String;
//     email : String;
// };

// type Email {
//     Email_01 : EmailsAddresses_01;
//     Email_02 : many EmailsAddresses_02;
//     Email_03 : many {
//         Kind  : String;
//         Email : String;
//     };
// };

// entity Emails {
//     Emails : Email;
// };

type Dec  : Decimal(16, 2);

// entity Car {
//     key ID                 : UUID;
//         Name               : String;
//         virtual Discount_1 : Decimal;
//         virtual Discoubt_2 : Decimal;
// };

entity Products {
    key ID               : UUID;
        Name             : String not null;
        Description      : String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now;
        DiscontinuedDate : DateTime;
        Price            : Dec;
        Height           : type of Price;
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
};

entity Suppliers {
    key ID      : UUID;
        Name    : type of Products : Name;
        Address : Address;
        Email   : String;
        Phone   : String;
        Fax     : String;
};

entity Categories {
    key ID   : String(1);
        Name : String;

};

entity StockAvailability {
    key ID          : Integer;
        Description : String;
};

entity Currencies {
    key ID          : String(3);
        Description : String;
};

entity UnitOfMeasures {
    key ID          : String(2);
        Description : String;
};

entity DimensionUnits {
    key ID          : String(2);
        Description : String;
};

entity Months {
    key ID               : String(2);
        Description      : String;
        ShortDescription : String(3);
};

entity ProductReviews {
    key ID           : UUID;
        ToProduct_Id : UUID;
        CreatedAt    : DateTime;
        Name         : String;
        Rating       : Integer;
        comment      : String;
};

entity SalesData {
    key ID           : UUID;
        DeliveryDate : DateTime;
        Revenue      : Decimal(16, 2);
};

// type Gender : String enum {
//     male;
//     female;
// };

// entity Order {
//     ClientGender : Gender;
//     Status       : Integer enum {
//         Submitted = 1;
//         Fulfiller = 2;
//         Shipped = 3;
//         Cancel = 4;
//     };
//     Priority     : String enum {
//         High;
//         Medium;
//         Low;
//     };
// };

entity SelProducts   as select from Products;

entity SelProducts1  as
    select from Products {
        *
    };

entity SelProducts2  as
    select from Products {
        Name,
        Price,
        Quantity
    };

entity SelProducts3  as
    select from Products
    left join ProductReviews
        on Products.Name = ProductReviews.Name
    {
        Rating,
        Products.Name,
        Sum(Price) as TotalPrice
    }
    group by
        Rating,
        Products.Name
    order by
        Rating;

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

// entity ParamProducts(pname: String)     as
//     select from Products {
//         Name,
//         Price,
//         Quantity
//     }
//     where
//         Name = :pname;

// entity ProjParamProducts(pname: String) as projection on Products
//                                            where
//                                                Name = :pname;

extend Products with {
    PriceCondition     : String(2);
    PriceDetermination : String(3);
}
