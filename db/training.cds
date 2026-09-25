namespace com.training;

using {
    cuid,
    Country
} from '@sap/cds/common';

entity Course : cuid {
    // key ID      : UUID;
    Student : Association to many StudentCourse
                  on Student.Course = $self;
}

entity Student : cuid {
    // key ID     : UUID;
    Course : Association to many StudentCourse
                 on Course.Student = $self;
};

entity StudentCourse : cuid {
    // key ID      : UUID;
    Student : Association to Student;
    Course  : Association to Course;
}

entity Orders {
    key ClientEmail : String(65);
        FirstName   : String(39);
        LastName    : String(30);
        CreateOn    : Date;
        Reviewed    : Boolean;
        Approved    : Boolean;
        Country     : Country;
        Status      : String(1);
}

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

// entity Car {
//     key ID                 : UUID;
//         Name               : String;
//         virtual Discount_1 : Decimal;
//         virtual Discoubt_2 : Decimal;
// };

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

// entity SelProducts3  as
//     select from Products
//     left join ProductReviews
//         on Products.Name = ProductReviews.Name
//     {
//         Rating,
//         Products.Name,
//         Sum(Price) as TotalPrice
//     }
//     group by
//         Rating,
//         Products.Name
//     order by
//         Rating;

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
