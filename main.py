import requests
import json
import os

whitFile = "whitelist.json"
rbxAPI = "https://friends.roblox.com/v1/users"
rbxSession = requests.Session()

def getToken():
    """Fetches the CSRF token from Roblox."""
    response = rbxSession.post("https://auth.roblox.com/v2/logout")
    return response.headers.get("X-CSRF-TOKEN", "")

def getFriends(user_id):
    """Fetches the list of friends for a given user."""
    url = f"{rbxAPI}/{user_id}/friends"
    response = rbxSession.get(url)

    if response.status_code == 200:
        data = response.json()
        return [{"Username": friend["name"], "UserID": friend["id"]} for friend in data["data"]]
    else:
        print(f"Error: Unable to fetch friends (Status Code: {response.status_code})")
        return None

def createWhit(user_id):
    """Creates and saves a whitelist of friends."""
    friends = getFriends(user_id)
    if friends:
        with open(whitFile, "w") as file:
            json.dump(friends, file, indent=4)
        print(f"Whitelist created successfully! ({len(friends)} friends saved)")
    else:
        print("Failed to create whitelist!")

def loadWhit():
    """Loads the whitelist from the file."""
    if os.path.exists(whitFile):
        with open(whitFile, "r") as file:
            return json.load(file)
    return None

def removeFcks(user_id, roblox_cookie):
    """Removes friends that are NOT in the whitelist."""
    friends = getFriends(user_id)
    if friends is None:
        return

    whitelist = loadWhit()
    if whitelist:
        whitelisted_ids = {friend["UserID"] for friend in whitelist}
    else:
        print("WARNING! No whitelist found. This will remove ALL friends.")
        confirm = input("Are you sure you want to continue? (yes/no): ").strip().lower()
        if confirm != "yes":
            print("Returning to main menu...")
            return
        whitelisted_ids = set()

    # Token shit
    rbxSession.cookies[".ROBLOSECURITY"] = roblox_cookie
    csrf_token = getToken()
    headers = {"X-CSRF-TOKEN": csrf_token}

    removed_count = 0

    for friend in friends:
        if friend["UserID"] not in whitelisted_ids:
            unfriend_url = f"https://friends.roblox.com/v1/users/{friend['UserID']}/unfriend"
            response = rbxSession.post(unfriend_url, headers=headers)

            if response.status_code == 200:
                print(f"Removed: {friend['Username']} ({friend['UserID']})")
                removed_count += 1
            else:
                print(f"Failed to remove {friend['Username']}. CSRF token might be invalid.")

    print(f"Process completed. Removed {removed_count} friends.")

def main():
    """Launcher menu."""
    user_id = input("Enter your Roblox User ID: ")

    while True:
        print("\n: 1 Create whitelist")
        print(": 2 Remove non-whitelisted friends")
        print(": 3 Exit")

        choice = input("Choose an option: ").strip()

        if choice == "1":
            createWhit(user_id)
        elif choice == "2":
            roblox_cookie = input("Enter your .ROBLOSECURITY cookie: ").strip()
            removeFcks(user_id, roblox_cookie)
        elif choice == "3":
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")

main()
