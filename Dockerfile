FROM microsoft/dotnet:2.1-sdk


#install node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

#install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install -y yarn git

#make a folder for the app and add it for the installation tools to work propperly
RUN mkdir -p /app
WORKDIR /app
ONBUILD ADD . /app

#install fable and templates
ONBUILD RUN dotnet new -i Fable.Template
ONBUILD RUN dotnet new -i Fable.Template.Elmish.React

#install node and dotnet packages 
ONBUILD RUN yarn install
ONBUILD WORKDIR /app/src
ONBUILD RUN dotnet restore

#create the fable tooling
ONBUILD WORKDIR ../tools
ONBUILD RUN dotnet build DotnetCLI.fsproj

#clean up. The source should be mounted at this location to make hot loading on file change possible
ONBUILD RUN rm -rf /app/src

#start the app
WORKDIR /app/tools
CMD ["dotnet", "fable", "yarn-start"]