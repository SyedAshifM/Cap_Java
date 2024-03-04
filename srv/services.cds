using { sap.capire.bookstore as db } from '../db/schema';

// Define Books Service
service BooksService {
    @readonly entity Books as projection   on db.Books { *, category as genre } excluding { category, createdBy, createdAt, modifiedBy, modifiedAt };
    @readonly entity Authors as projection on db.Authors;
}

// Define Orders Service
service OrdersService {
    // @(restrict: [
    //     { grant: '*', to: 'Administrators' },
    //     { grant: '*', where: 'createdBy = $user'}, 
    //     // { grant: 'READ', to: 'Viewer', where: 'createdBy = $user'},
    // ])

    entity Orders as projection on db.Orders;
    
    annotate Orders with @restrict :[
        {
            grant : 'READ',
            to : 'Viewer'
        },
        {
            grant : ['CREATE','READ'],
            to : 'Administrators'
        },
        
        //  {
        //     grant : ['CREATE','READ'],
        //     where : 'createdBy = $user'
        // }
    ];    

    @(restrict: [
        { grant: '*', to: 'Administrators' },
        { grant: '*', where: 'parent.createdBy = $user' },
    ])
    entity OrderItems as projection on db.OrderItems;
}


// Reuse Admin Service
using { AdminService } from '@sap/capire-products';
extend service AdminService with {
    entity Authors as projection on db.Authors;
}

annotate AdminService @(requires: 'Administrators');