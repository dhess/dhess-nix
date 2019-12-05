{ lib
, python
}:

let
  py = python.override {
    packageOverrides = self: super: {
      aws-sam-translator = super.aws-sam-translator.overridePythonAttrs (oldAttrs: rec {
        version = "1.19.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1i9ff2q9w2v8rrxm6vib5hpsin295pzavvk62dhvz0jkvyivzvr8";
        };
      });

      boto3 = super.boto3.overridePythonAttrs (oldAttrs: rec {
        version = "1.10.33";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1vcmr89g3y1nviyd52lczy08ggzsvsm82vr9mfpfhwy3gnzz506j";
        };
      });

      botocore = super.botocore.overridePythonAttrs (oldAttrs: rec {
        version = "1.13.33";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1z5fd5mvbggg8hmlhycwgi8i47shiqgw64qnm5yzkcxha9dphqa8";
        };
      });

      dateutil = super.dateutil.overridePythonAttrs (oldAttrs: rec {
        version = "2.8.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "17nsfhy4xdz1khrfxa61vd7pmvd5z0wa3zb6v4gb4kfnykv0b668";
        };
      });

      flask = super.flask.overridePythonAttrs (oldAttrs: rec {
        version = "1.0.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0j6f4a9rpfh25k1gp7azqhnni4mb4fgy50jammgjgddw1l3w0w92";
        };
      });

      jsonschema = super.jsonschema.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0grwi50v3vahvcijlw6g6q55yc5jyj0p1cmiq3rkycxnfr16i81g";
        };
        nativeBuildInputs = [ super.setuptools_scm ];
        propagatedBuildInputs = with super; oldAttrs.propagatedBuildInputs ++ [ pyrsistent attrs importlib-metadata ];
        doCheck = false;
      });

    };
  };

in

with py.pkgs;

buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "0.37.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pkkl5wswsnbspy7i8qcp0wpabcs21hqf6rlf9cyfq16234kf3ax";
  };

  # Tests are not included in the PyPI package
  doCheck = false;

  propagatedBuildInputs = [
    aws-lambda-builders
    aws-sam-translator
    chevron
    click
    cookiecutter
    dateparser
    docker
    flask
    idna
    pathlib2
    requests
    serverlessrepo
    six
    tomlkit
  ];

  # fix over-restrictive version bounds
  postPatch = ''
    substituteInPlace requirements/base.txt --replace "requests==2.20.1" "requests==2.22.0"
    substituteInPlace requirements/base.txt --replace "serverlessrepo==0.1.9" "serverlessrepo~=0.1.9"
    substituteInPlace requirements/base.txt --replace "six~=1.11.0" "six~=1.12.0"
    substituteInPlace requirements/base.txt --replace "PyYAML~=3.12" "PyYAML~=5.1"
  '';

  meta = with lib; {
    homepage = https://github.com/awslabs/aws-sam-cli;
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ andreabedini dhkl ];
  };
}
