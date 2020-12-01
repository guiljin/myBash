FROM docker-mirror.sh.synyi.com/microsoft/dotnet:2.1-sdk
WORKDIR /codeanalysis
COPY . .
RUN dotnet new console && \
    dotnet add package Microsoft.CodeAnalysis.FxCopAnalyzers && \
    dotnet add package StyleCop.Analyzers && \
    dotnet restore && \
    sed -i '5a<CodeAnalysisRuleSet>ca.ruleset</CodeAnalysisRuleSet>' codeanalysis.csproj && \
    dotnet build