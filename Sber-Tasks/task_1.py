import math
n = int(input("Введите количество промежутков между существующими банкоматами: "))
k = int(input("Введите количество новых банкоматов для добавления: "))
distance_l = [] # L по условию задачи
for i in range(n):
    print(f"Введите {i+1} исходное расстояние:", end=" ")
    distance_l.append(int(input()))
print(f"{n} - Количество промежутков между существующими банкоматами \n{k} - Количество новых банкоматов для добавления \n{distance_l} - Список из n натуральных чисел, представляющих исходные расстояния")


def bool_check(x, k, distance_l): 
    return sum((i - 1)// x for i in distance_l) <= k
    
def binary_search_distance(k,distance_l):
    min_l = 1
    max_l = max(distance_l)
    
    while (min_l < max_l):
        mid = (min_l + max_l) //2
        if bool_check(mid,k,distance_l):
            max_l = mid
        else:
            min_l = mid + 1
            
    x = min_l
    new_distance_l = []
    
    for i in distance_l:
        p = max(1,math.ceil(i/x))
        base, rem = divmod(i,p)
        new_distance_l.extend([base] * (p - rem) + [base + 1]* rem)
    return new_distance_l

new_distance_l = binary_search_distance(k,distance_l)
print()
print(f"Новые расстояния между банкоматами {new_distance_l}")