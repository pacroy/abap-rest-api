# Simple ABAP REST API

Clone or import using [abapGit](https://github.com/larshp/abapGit)

Visit my blogs related to this repository:

- [Developing Plain RESTful APIs in ABAP — An Alternative to OData](https://medium.com/pacroy/developing-apis-in-abap-just-rest-not-odata-d91cf899f7d3) on Medium
- [Continuous Integration in ABAP using Jenkins](https://blogs.sap.com/2017/11/11/continuous-integration-in-abap-using-jenkins/) on SAP Blogs
- [Continuous Integration in ABAP](https://medium.com/pacroy/continuous-integration-in-abap-3db48fc21028) on Medium

## Test Instructions

### With Postman

1. Import both JSON files into [Postman](https://www.getpostman.com/)
2. Open _GetToken_ test and go to tab _Authorization_ and set username and password accordingly.
3. Run

### With Newman

```
newman run SimpleRESTTest.postman_collection.json --environment NPL.postman_environment.json --global-var username=<username> --global-var password=<password>
newman
```

Replace `<username>` and `<password>` accordingly.
