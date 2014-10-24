// Capitalize the first letter of the string
String.prototype.capitalize = function () {
  return this.charAt(0).toUpperCase() + this.slice(1);
}
