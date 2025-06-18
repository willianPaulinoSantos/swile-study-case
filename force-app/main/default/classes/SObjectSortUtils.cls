public with sharing class SObjectSortUtils {

    public static List<SObject> quickSortByNumericField(List<SObject> objectList, String fieldName) {

        if (objectList == null || objectList.size() <= 1 || String.isBlank(fieldName)) {

            return objectList;
        }

        return quickSortRecursive(objectList, fieldName, 0, objectList.size() - 1);
    }

    private static List<SObject> quickSortRecursive(List<SObject> objectList, String fieldName, Integer lowerIndex, Integer higherIndex) {

        if (lowerIndex < higherIndex) {
            Integer pivotIndex = partition(objectList, fieldName, lowerIndex, higherIndex);
            quickSortRecursive(objectList, fieldName, lowerIndex, pivotIndex - 1);
            quickSortRecursive(objectList, fieldName, pivotIndex + 1, higherIndex);
        }

        return objectList;
    }

    private static Integer partition(List<SObject> objectList, String fieldName, Integer lowerIndex, Integer higherIndex) {

        Integer pivot = convertToInteger(objectList[higherIndex].get(fieldName));
        Integer lastSmallerIndex = lowerIndex - 1;

        for (Integer currentIndex = lowerIndex; currentIndex < higherIndex; currentIndex++) {
            if (convertToInteger(objectList[currentIndex].get(fieldName)) <= pivot) {
                lastSmallerIndex++;
                swap(objectList, lastSmallerIndex, currentIndex);
            }
        }

        swap(objectList, lastSmallerIndex + 1, higherIndex);
        return lastSmallerIndex + 1;
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