[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "orders_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "OrderDate", DestinationColumnName = "OrderDate"], [SourceColumnName = "CustomerID", DestinationColumnName = "CustomerID"], [SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "Quantity", DestinationColumnName = "Quantity"], [SourceColumnName = "Line Total", DestinationColumnName = "Line Total"], [SourceColumnName = "Unit Price", DestinationColumnName = "Unit Price"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared orders = let
  Source = Csv.Document(Web.Contents("https://raw.githubusercontent.com/MicrosoftLearning/dp-data/main/orders.csv"), [Delimiter = ",", Columns = 7, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"SalesOrderID", Int64.Type}, {"OrderDate", type date}, {"CustomerID", Int64.Type}, {"LineItem", Int64.Type}, {"ProductID", Int64.Type}, {"OrderQty", Int64.Type}, {"LineItemTotal", type number}}),
  #"Choose columns" = Table.SelectColumns(#"Changed column type", {"OrderDate", "CustomerID", "LineItem", "OrderQty", "LineItemTotal"}),
  #"Filtered rows" = Table.SelectRows(#"Choose columns", each [OrderDate] <> null and [OrderDate] <> ""),
  #"Filtered rows 1" = Table.SelectRows(#"Filtered rows", each [OrderQty] > 0),
  #"Renamed columns" = Table.RenameColumns(#"Filtered rows 1", {{"OrderQty", "Quantity"}, {"LineItemTotal", "Line Total"}, {"LineItem", "Item"}}),
  #"Added custom" = Table.TransformColumnTypes(Table.AddColumn(#"Renamed columns", "Unit Price", each [Line Total] / [Quantity]), {{"Unit Price", type number}}),
  #"Rounded off" = Table.TransformColumns(#"Added custom", {{"Unit Price", each Number.Round(_, 2), type number}})
in
  #"Rounded off";
shared orders_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "ddd7637e-f578-4439-b0d0-5a872019ac54"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "3bcbbb25-74ae-4576-aaa7-0ea3e65c0ac4"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "orders", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
