[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared usecase4 = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "7ecdfbeb-7580-41e6-b878-4f0a175a193a"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "2781f769-5494-46b7-89a8-72b32892f055"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Name = "data"]}[Content],
  #"Navigation 4" = #"Navigation 3"{[Name = "usecase4"]}[Content],
  #"Navigation 5" = #"Navigation 4"{[Name = "Sales.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 5", [Delimiter = ",", Columns = 7, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"OrderID", Int64.Type}, {"OrderDate", type text}, {"CustomerID", Int64.Type}, {"ProductID", Int64.Type}, {"StoreID", Int64.Type}, {"Quantity", Int64.Type}, {"Discount", Int64.Type}})
in
  #"Changed column type";
