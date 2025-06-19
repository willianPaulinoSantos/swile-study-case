public with sharing class SObjectSortUtils {

    public static List<SObject> quickSortByNumericField(List<SObject> objectList, String fieldName) {

        if (objectList == null || objectList.size() <= 1 || String.isBlank(fieldName)) {

            return objectList;
        }

        return quickSort(objectList, 0, objectList.size() - 1, fieldName);
    }

    private static List<SObject> quickSort(List<SObject> objectList, Integer startIndex, Integer endIndex, String fieldName) {

        if (startIndex < endIndex) {
            Integer pivotIndex = partition(objectList, startIndex, endIndex, fieldName);
            quickSort(objectList, startIndex, pivotIndex - 1, fieldName);
            quickSort(objectList, pivotIndex + 1, endIndex, fieldName);
        }

        return objectList;
    }

    private static Integer partition(List<SObject> objectList, Integer startIndex, Integer endIndex,  String fieldName) {

        Integer pivot = convertToInteger(objectList[endIndex].get(fieldName));
        Integer i = startIndex - 1;

        for (Integer j = startIndex; j < endIndex; j++) {
            if (convertToInteger(objectList[j].get(fieldName)) <= pivot) {
                i++;
                swap(objectList, i, j);
            }
        }

        swap(objectList, i + 1, endIndex);
        return i + 1;
    }

    public static List<SObject> bubbleSortByNumericField(List<SObject> objectList, String fieldName) {
        if (objectList == null || objectList.size() <= 1 || String.isBlank(fieldName)) {
            return objectList;
        }

        Integer n = objectList.size();

        for (Integer pass = 0; pass < n - 1; pass++) {
            Boolean swapped = false;
            for (Integer i = 0; i < n - 1 - pass; i++) {
                Integer first = convertToInteger(objectList[i].get(fieldName));
                Integer second = convertToInteger(objectList[i + 1].get(fieldName));

                if (first > second) {
                    swap(objectList, i, i + 1);
                    swapped = true;
                }
            }
            if (!swapped) {
                break; // Early exit if no swaps occurred in this pass
            }
        }

        return objectList;
    }

    private static void swap(List<SObject> objectList, Integer i, Integer j) {
        SObject temp = objectList[i];
        objectList[i] = objectList[j];
        objectList[j] = temp;
    }

    private static Integer convertToInteger(Object value) {
        if (value == null) return 0;
        if (value instanceof Decimal) return Integer.valueOf((Decimal)value);
        if (value instanceof Integer) return (Integer)value;
        return 0;
    }
}