import ballerina/http;
import ballerina/log;

type customerRecordsResponse record {
    Customer[] customers?;
};

type Customer record {
    readonly string customer_id;
    string customer_name;
    string dob;
    string contact_no;
};

final table<Customer> key(customer_id) customerRecords = table [
    {
        customer_id: "0001",
        customer_name: "Jerad Gregson",
        dob: "1985-12-09",
        contact_no: "+4477121212121"
    },
    {
        customer_id: "0002",
        customer_name: "Harry Millers",
        dob: "1972-02-14",
        contact_no: "+4477144444444"
    },
    {
        customer_id: "0003",
        customer_name: "Bob Smith",
        dob: "1982-11-11",
        contact_no: "+4477188888888"
    },
    {
        customer_id: "0004",
        customer_name: "David Brown",
        dob: "1989-08-08",
        contact_no: "+4477200000000"
    },
    {
        customer_id: "0005",
        customer_name: "Frank Green",
        dob: "1994-04-04",
        contact_no: "+4477222222222"
    }
];
service / on new http:Listener(9090) {

    resource function get customer() returns error?|customerRecordsResponse {

        log:printInfo("Received request to GET customer records");
        customerRecordsResponse response = {};
        
        Customer[] customers = [];
        foreach Customer cust in customerRecords {  
            customers.push(cust);
        }
        response = {customers};
        return response;
    }

    resource function post customer(@http:Payload Customer customerData) returns http:Ok|http:BadRequest|error {
        
        log:printInfo("Received request to POST a customer record");

        if (customerData.contact_no.length() == 0 || customerData.dob.length() == 0 || customerData.customer_id.length() == 0 || customerData.customer_name.length() ==0  ) {
            http:BadRequest err = {body: "Bad Request"};
            return err;
        }

        Customer cust = {customer_id: customerData.customer_id, customer_name: customerData.customer_name, dob: customerData.dob, contact_no: customerData.contact_no};
        customerRecords.add(cust);
        http:Ok response = { body: { status: "ok" } };
        return response;
    }
}