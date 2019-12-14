<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Country Code Services</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script defer src="https://use.fontawesome.com/releases/v5.1.0/js/all.js"></script>
  </head>
  <body>
    <div class="jumbotron">
      <h1 class="display-3 text-center">Country Code Services</h1>
    </div>
    <div class="row container-fluid">
        <div class="col-sm-6">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title">Code to Country Service</h5>
              <p class="card-text text-secondary">Enter an international calling code to retrieve the associated country name</p>
              <form>
                <div class="row mb-1">
                  <div class="col">
                    <input id="country-input" type="text" class="form-control" placeholder="Calling Code">
                  </div>
                  <div class="col">
                    <a id="country-submit" class="btn btn-primary text-white">Submit</a>
                  </div>
                </div>
                <div class="row">
                  <div id="country-output" class="col"></div>
                </div>
              </form>
            </div>
          </div>
        </div>
        <div class="col-sm-6">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title">Country to Code Service</h5>
              <p class="card-text text-secondary">Enter a country name to retrieve the associated international calling code</p>
              <form>
                <div class="row mb-1">
                  <div class="col">
                    <input id="code-input" type="text" class="form-control" placeholder="Country">
                  </div>
                  <div class="col">
                    <a id="code-submit" class="btn btn-primary text-white">Submit</a>
                  </div>
                </div>
                <div class="row">
                  <div id="code-output" class="col"></div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
  </body>
</html>
